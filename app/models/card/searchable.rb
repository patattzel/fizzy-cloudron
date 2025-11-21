module Card::Searchable
  extend ActiveSupport::Concern

  included do
    include ::Searchable

    has_many :card_search_records, class_name: "Search::Record"

    scope :mentioning, ->(query, user:) do
      joins(:card_search_records).merge(Search::Record.for_query(query: Search::Query.wrap(query), user: user))
    end
  end

  def search_title
    title
  end

  def search_content
    description.to_plain_text
  end

  def search_card_id
    id
  end

  def search_board_id
    board_id
  end
end
