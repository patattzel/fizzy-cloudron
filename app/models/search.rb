class Search
  attr_reader :user, :query

  HIGHLIGHT_OPENING_MARK = "<mark class=\"circled-text\"><span></span>"
  HIGHLIGHT_CLOSING_MARK = "</mark>"

  def self.table_name_prefix
    "search_"
  end

  def initialize(user, query)
    @user = user
    @query = Query.wrap(query)
  end

  def results
    if query.valid? && board_ids.any?
      perform_search
    else
      Search::Result.none
    end
  end

  private
    def board_ids
      @board_ids ||= user.board_ids
    end

    def perform_search
      query_string = query.to_s
      sanitized_query = Search::Result.connection.quote(query_string)

      Search::Result.from("search_index")
        .joins("INNER JOIN cards ON search_index.card_id = cards.id")
        .joins("INNER JOIN boards ON cards.board_id = boards.id")
        .where("search_index.board_id IN (?)", board_ids)
        .where("MATCH(search_index.content, search_index.title) AGAINST(? IN BOOLEAN MODE)", query_string)
        .select([
          "search_index.card_id as card_id",
          "CASE WHEN search_index.searchable_type = 'Comment' THEN search_index.searchable_id ELSE NULL END as comment_id",
          "COALESCE(search_index.title, cards.title) AS card_title_in_database",
          "CASE WHEN search_index.searchable_type = 'Card' THEN search_index.content ELSE NULL END AS card_description_in_database",
          "CASE WHEN search_index.searchable_type = 'Comment' THEN search_index.content ELSE NULL END AS comment_body_in_database",
          "boards.name as board_name",
          "cards.creator_id",
          "search_index.created_at as created_at",
          "MATCH(search_index.content, search_index.title) AGAINST(#{sanitized_query} IN BOOLEAN MODE) AS score"
        ].join(","))
        .order("search_index.created_at DESC")
    end
end
