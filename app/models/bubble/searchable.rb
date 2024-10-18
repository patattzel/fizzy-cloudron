module Bubble::Searchable
  extend ActiveSupport::Concern

  included do
    include ::Searchable

    searchable_by :title, using: :bubbles_search_index

    scope :mentioning, ->(query) do
      if query = query.presence
        bubbles = search(query).select(:id).to_sql
        comments = Comment.search(query).select(:bubble_id).to_sql
        left_joins(:comments).where("bubbles.id in (#{bubbles}) or comments.bubble_id in (#{comments})").distinct
      end
    end
  end
end
