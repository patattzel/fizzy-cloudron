module Searchable
  extend ActiveSupport::Concern

  included do
    after_create_commit :create_in_search_index
    after_update_commit :update_in_search_index
    after_destroy_commit :remove_from_search_index

    scope :search, ->(query) do
      query = Search::Query.wrap(query)

      base = joins("INNER JOIN search_index ON search_index.searchable_type = '#{name}' AND search_index.searchable_id = #{table_name}.id")

      if query.valid?
        base.where("MATCH(search_index.content, search_index.title) AGAINST(? IN BOOLEAN MODE)", query.to_s)
      else
        base.none
      end
    end
  end

  def reindex
    update_in_search_index
  end

  private
    def create_in_search_index
      self.class.connection.execute self.class.sanitize_sql([
        "INSERT INTO search_index (searchable_type, searchable_id, card_id, board_id, title, content, created_at) VALUES (?, ?, ?, ?, ?, ?, ?)",
        self.class.name,
        id,
        search_card_id,
        search_board_id,
        search_title,
        search_content,
        created_at
      ])
    end

    def update_in_search_index
      result = self.class.connection.execute(self.class.sanitize_sql([
        "UPDATE search_index SET card_id = ?, board_id = ?, title = ?, content = ?, created_at = ? WHERE searchable_type = ? AND searchable_id = ?",
        search_card_id,
        search_board_id,
        search_title,
        search_content,
        created_at,
        self.class.name,
        id
      ]))

      create_in_search_index if result.affected_rows == 0
    end

    def remove_from_search_index
      self.class.connection.execute self.class.sanitize_sql([
        "DELETE FROM search_index WHERE searchable_type = ? AND searchable_id = ?",
        self.class.name,
        id
      ])
    end

    # Models must implement these methods:
    # - search_title: returns title string or nil
    # - search_content: returns content string
    # - search_card_id: returns the card id (self.id for cards, card_id for comments)
    # - search_board_id: returns the board id
end
