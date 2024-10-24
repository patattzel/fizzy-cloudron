module Bubble::Commentable
  extend ActiveSupport::Concern

  included do
    has_many :comments # destroyed via thread_entry
    scope :ordered_by_comments, -> { left_joins(:comments).group(:id).order("COUNT(comments.id) DESC") }
  end
end
