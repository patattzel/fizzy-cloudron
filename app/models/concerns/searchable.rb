module Searchable
  extend ActiveSupport::Concern

  included do
    after_create_commit :create_in_search_index
    after_update_commit :update_in_search_index
    after_destroy_commit :remove_from_search_index
  end

  def reindex
    update_in_search_index
  end

  private
    def create_in_search_index
      search_class = Search::Record.for_account(account_id)

      if Search::Record.sqlite?
        # SQLite: create with unstemmed content, FTS5 handles stemming
        record = search_class.create!(search_record_attributes)
        upsert_to_fts5(record.id)
      else
        # MySQL: create with stemmed content for FULLTEXT search
        attrs = search_record_attributes.merge(
          title: Search::Stemmer.stem(search_record_attributes[:title]),
          content: Search::Stemmer.stem(search_record_attributes[:content])
        )
        search_class.create!(attrs)
      end
    end

    def update_in_search_index
      search_class = Search::Record.for_account(account_id)

      if Search::Record.sqlite?
        # SQLite: find or create record, then upsert to FTS5
        record = search_class.find_or_initialize_by(
          searchable_type: self.class.name,
          searchable_id: id
        )
        record.assign_attributes(search_record_attributes)
        record.save!
        upsert_to_fts5(record.id)
      else
        # MySQL: use upsert_all with stemmed content
        attrs = search_record_attributes.merge(
          id: ActiveRecord::Type::Uuid.generate,
          title: Search::Stemmer.stem(search_record_attributes[:title]),
          content: Search::Stemmer.stem(search_record_attributes[:content])
        )
        search_class.upsert_all(
          [ attrs ],
          update_only: [ :card_id, :board_id, :title, :content, :created_at ]
        )
      end
    end

    def remove_from_search_index
      search_class = Search::Record.for_account(account_id)
      record = search_class.find_by(searchable_type: self.class.name, searchable_id: id)

      if record
        # For SQLite, delete from FTS5 first
        if Search::Record.sqlite?
          delete_from_fts5(record.id)
        end

        record.delete
      end
    end

    def upsert_to_fts5(record_id)
      # Use raw unstemmed text - FTS5 Porter tokenizer handles stemming automatically
      title = search_title
      content = search_content

      # Note: FTS5 virtual tables don't work properly with bound parameters in SQLite,
      # so we need to use string interpolation with proper quoting
      conn = ActiveRecord::Base.connection
      sql = "INSERT OR REPLACE INTO search_records_fts(rowid, title, content) VALUES (#{record_id}, #{conn.quote(title)}, #{conn.quote(content)})"
      conn.execute(sql)
    end

    def delete_from_fts5(record_id)
      # Note: Use string interpolation for consistency (rowid is always an integer, so safe)
      ActiveRecord::Base.connection.execute(
        "DELETE FROM search_records_fts WHERE rowid = #{record_id}"
      )
    end

    def search_record_attributes
      {
        account_id: account_id,
        searchable_type: self.class.name,
        searchable_id: id,
        card_id: search_card_id,
        board_id: search_board_id,
        title: search_title,
        content: search_content,
        created_at: created_at || Time.current
      }
    end

  # Models must implement these methods:
  # - account_id: returns the account id
  # - search_title: returns title string or nil
  # - search_content: returns content string
  # - search_card_id: returns the card id (self.id for cards, card_id for comments)
  # - search_board_id: returns the board id
end
