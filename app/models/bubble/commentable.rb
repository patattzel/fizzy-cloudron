module Bubble::Commentable
  extend ActiveSupport::Concern

  included do
    has_many :comment_messages, -> { comments }, class_name: "Message"
    has_many :comments, through: :comment_messages, source: :messageable, source_type: "Comment"

    scope :ordered_by_comments, -> { left_joins(:comment_messages).group(:id).order("COUNT(messages.id) DESC") }
  end

  def comment(body)
    capture Comment.new(body: body)
  end
end
