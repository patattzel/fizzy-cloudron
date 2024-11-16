module Bubble::Commentable
  extend ActiveSupport::Concern

  included do
    scope :ordered_by_comments, -> { order comments_count: :desc }
  end

  def comment_captured
    increment! :comments_count
    rescore
  end

  def comment_uncaptured
    decrement! :comments_count
    rescore
  end
end
