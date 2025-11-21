module Search::Record::SQLite
  extend ActiveSupport::Concern

  included do
    # Override the UUID id attribute from ApplicationRecord
    # FTS tables require integer rowids
    attribute :id, :integer, default: nil

    # Virtual attributes from FTS5 functions
    attribute :result_title, :string
    attribute :result_content, :string

    after_save :upsert_to_fts5_table
    after_destroy :delete_from_fts5_table

    scope :matching, ->(query, account_id) do
      joins("INNER JOIN search_records_fts ON search_records_fts.rowid = #{table_name}.id")
        .where("search_records_fts MATCH ?", query)
    end
  end

  class_methods do
    def search_fields(query)
      opening_mark = connection.quote(Search::Highlighter::OPENING_MARK)
      closing_mark = connection.quote(Search::Highlighter::CLOSING_MARK)
      ellipsis = connection.quote(Search::Highlighter::ELIPSIS)

      [ "highlight(search_records_fts, 0, #{opening_mark}, #{closing_mark}) AS result_title",
        "snippet(search_records_fts, 1, #{opening_mark}, #{closing_mark}, #{ellipsis}, 20) AS result_content",
        "#{connection.quote(query.terms)} AS query" ]
    end
  end

  def card_title
    escape_fts_highlight(result_title || card.title)
  end

  def card_description
    escape_fts_highlight(result_content) unless comment
  end

  def comment_body
    escape_fts_highlight(result_content) if comment
  end

  private
    def escape_fts_highlight(html)
      return nil unless html.present?

      CGI.escapeHTML(html)
        .gsub(CGI.escapeHTML(Search::Highlighter::OPENING_MARK), Search::Highlighter::OPENING_MARK.html_safe)
        .gsub(CGI.escapeHTML(Search::Highlighter::CLOSING_MARK), Search::Highlighter::CLOSING_MARK.html_safe)
        .html_safe
    end

    def upsert_to_fts5_table
      self.class.connection.exec_query(
        "INSERT OR REPLACE INTO search_records_fts(rowid, title, content) VALUES (?, ?, ?)",
        "Search::Record Upsert FTS5",
        [id, title, content]
      )
    end

    def delete_from_fts5_table
      self.class.connection.exec_query(
        "DELETE FROM search_records_fts WHERE rowid = ?",
        "Search::Record Delete FTS5",
        [id]
      )
    end
end
