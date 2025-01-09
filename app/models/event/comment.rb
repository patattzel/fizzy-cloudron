module Event::Comment
  extend ActiveSupport::Concern

  included do
    store_accessor :particulars, :comment_id
  end

  def comment
    @comment ||= Comment.find(comment_id)
  end
end
