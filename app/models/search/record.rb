class Search::Record < ApplicationRecord
  self.abstract_class = true

  SHARD_COUNT = 16

  # MySQL sharded table classes
  SHARD_CLASSES = SHARD_COUNT.times.map do |shard_id|
    Class.new(self) do
      self.table_name = "search_records_#{shard_id}"

      def self.name
        "Search::Record"
      end
    end
  end.freeze

  belongs_to :searchable, polymorphic: true, optional: true
  belongs_to :card, optional: true

  # Virtual attributes from search query
  attribute :query, :string

  validates :account_id, :searchable_type, :searchable_id, :card_id, :board_id, :created_at, presence: true

  before_save :stem_content, unless: :sqlite?
  after_save :upsert_to_fts5_table, if: :sqlite?
  after_destroy :delete_from_fts5_table, if: :sqlite?

  class << self
    def sqlite?
      connection.adapter_name == "SQLite"
    end

    def upsert_to_fts5(record_id, title:, content:)
      # Use raw unstemmed text - FTS5 Porter tokenizer handles stemming automatically
      # Note: FTS5 virtual tables don't work properly with bound parameters in SQLite,
      # so we need to use string interpolation with proper quoting
      conn = connection
      sql = "INSERT OR REPLACE INTO search_records_fts(rowid, title, content) VALUES (#{record_id}, #{conn.quote(title)}, #{conn.quote(content)})"
      conn.execute(sql)
    end

    def delete_from_fts5(record_id)
      # Note: Use string interpolation for consistency (rowid is always an integer, so safe)
      connection.execute(
        "DELETE FROM search_records_fts WHERE rowid = #{record_id}"
      )
    end

    def for_account(account_id)
      if sqlite?
        # SQLite uses a single table, no sharding - use a non-abstract subclass
        @sqlite_class ||= Class.new(self) do
          self.abstract_class = false
          self.table_name = "search_records"

          # Override the UUID id attribute from ApplicationRecord
          # SQLite uses integer auto-increment primary key (no default)
          attribute :id, :integer, default: nil

          def self.name
            "Search::Record"
          end
        end
      else
        # MySQL uses sharded tables
        SHARD_CLASSES[shard_id_for_account(account_id)]
      end
    end

    def shard_id_for_account(account_id)
      Zlib.crc32(account_id.to_s) % SHARD_COUNT
    end

    def card_join
      "INNER JOIN #{table_name} ON #{table_name}.card_id = cards.id"
    end

    # Convert MySQL BOOLEAN MODE syntax to SQLite FTS5 syntax
    def convert_to_fts5_query(query)
      query = query.to_s.dup

      # Handle quoted phrases - these work the same in both
      # Extract them to protect during processing
      phrases = []
      query.gsub!(/"([^"]+)"/) do
        phrases << $1
        "__PHRASE_#{phrases.length - 1}__"
      end

      # Split into tokens
      tokens = query.split(/\s+/)

      processed_tokens = tokens.map do |token|
        if token.start_with?("__PHRASE_")
          # Restore phrase
          idx = token[/\d+/].to_i
          "\"#{phrases[idx]}\""
        elsif token.start_with?("+")
          # Remove + prefix (FTS5 ANDs by default)
          token[1..]
        elsif token.start_with?("-")
          # Convert -term to NOT term
          "NOT #{token[1..]}"
        else
          token
        end
      end

      # Join with AND (FTS5 uses AND/OR/NOT operators)
      processed_tokens.reject(&:blank?).join(" ")
    end
  end

  scope :for_query, ->(query:, user:) do
    if query.valid? && user.board_ids.any?
      matching(query.to_s).for_user(user)
    else
      none
    end
  end

  scope :matching, ->(query) do
    if sqlite?
      # SQLite FTS5: join on rowid for fast lookup with native highlighting
      # Porter tokenizer handles stemming automatically
      fts_query = convert_to_fts5_query(query)

      joins("INNER JOIN search_records_fts ON search_records_fts.rowid = #{table_name}.id")
        .where("search_records_fts MATCH ?", fts_query)
    else
      # MySQL FULLTEXT: manually stem query terms
      stemmed_query = Search::Stemmer.stem(query)
      where("MATCH(#{table_name}.content, #{table_name}.title) AGAINST(? IN BOOLEAN MODE)", stemmed_query)
    end
  end

  scope :for_user, ->(user) do
    where(account_id: user.account_id, board_id: user.board_ids)
  end

  scope :search, ->(query:, user:) do
    relation = for_query(query: query, user: user)
      .includes(:searchable, card: [ :board, :creator ])
      .order(created_at: :desc)

    if sqlite?
      # SQLite: matching scope already selected all columns + FTS5 highlight columns
      # Re-select to add query terms (ActiveRecord replaces the select list)
      opening_mark = Search::Highlighter::OPENING_MARK
      closing_mark = Search::Highlighter::CLOSING_MARK
      ellipsis = Search::Highlighter::ELIPSIS

      relation.select(
        "#{table_name}.id",
        "#{table_name}.account_id",
        "#{table_name}.searchable_type",
        "#{table_name}.searchable_id",
        "#{table_name}.card_id",
        "#{table_name}.board_id",
        "#{table_name}.title",
        "#{table_name}.content",
        "#{table_name}.created_at",
        "highlight(search_records_fts, 0, #{connection.quote(opening_mark)}, #{connection.quote(closing_mark)}) AS highlighted_title",
        "highlight(search_records_fts, 1, #{connection.quote(opening_mark)}, #{connection.quote(closing_mark)}) AS highlighted_content",
        "snippet(search_records_fts, 1, #{connection.quote(opening_mark)}, #{connection.quote(closing_mark)}, #{connection.quote(ellipsis)}, 20) AS content_snippet",
        "#{connection.quote(query.terms)} AS query"
      )
    else
      # MySQL: select specific columns needed
      relation.select(:id, :searchable_type, :searchable_id, :card_id, :board_id, :account_id, :created_at, "#{connection.quote(query.terms)} AS query")
    end
  end

  def sqlite?
    self.class.sqlite?
  end

  def source
    searchable_type == "Comment" ? searchable : card
  end

  def comment
    searchable if searchable_type == "Comment"
  end

  def card_title
    if card_id
      if self.class.sqlite? && attribute?(:highlighted_title)
        # Use FTS5 native highlighting (already HTML-safe from FTS5)
        highlighted_title.html_safe
      else
        # MySQL: use Ruby highlighter
        highlight(card.title, show: :full)
      end
    end
  end

  def card_description
    if card_id
      if self.class.sqlite? && attribute?(:content_snippet)
        # Use FTS5 native snippet for content (already HTML-safe from FTS5)
        content_snippet.html_safe if content_snippet.present?
      else
        # MySQL: use Ruby highlighter
        highlight(card.description.to_plain_text, show: :snippet)
      end
    end
  end

  def comment_body
    if comment
      if self.class.sqlite? && attribute?(:content_snippet)
        # Use FTS5 native snippet for content (already HTML-safe from FTS5)
        content_snippet.html_safe if content_snippet.present?
      else
        # MySQL: use Ruby highlighter
        highlight(comment.body.to_plain_text, show: :snippet)
      end
    end
  end

  private
    def stem_content
      # MySQL: stem content for FULLTEXT search
      self.title = Search::Stemmer.stem(title) if title_changed?
      self.content = Search::Stemmer.stem(content) if content_changed?
    end

    def upsert_to_fts5_table
      # Use raw unstemmed text - FTS5 Porter tokenizer handles stemming automatically
      self.class.upsert_to_fts5(id, title: title, content: content)
    end

    def delete_from_fts5_table
      self.class.delete_from_fts5(id)
    end

    def highlight(text, show:)
      if text.present? && attribute?(:query)
        highlighter = Search::Highlighter.new(query)
        show == :snippet ? highlighter.snippet(text) : highlighter.highlight(text)
      else
        text
      end
    end
end
