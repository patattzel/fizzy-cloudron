module Card::Searchable
  extend ActiveSupport::Concern

  included do
    include ::Searchable

    scope :mentioning, ->(query, board_ids:) do
      query = Search::Query.wrap(query)

      if query.valid?
        joins("INNER JOIN search_index ON search_index.card_id = cards.id AND search_index.board_id = cards.board_id")
          .where("search_index.board_id IN (?)", board_ids)
          .where("MATCH(search_index.content, search_index.title) AGAINST(? IN BOOLEAN MODE)", query.to_s)
          .distinct
      else
        none
      end
    end
  end

  private
    def search_title
      Search::Stemmer.stem title
    end

    def search_content
      Search::Stemmer.stem description.to_plain_text
    end

    def search_card_id
      id
    end

    def search_board_id
      board_id
    end
end
