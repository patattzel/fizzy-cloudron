class Comment < ApplicationRecord
  include Searchable, Messageable

  belongs_to :creator, class_name: "User", default: -> { Current.user }

  searchable_by :body, using: :comments_search_index

  def captured_as(message)
    message.bubble.comment_captured
  end

  def uncaptured_as(message)
    message.bubble.comment_uncaptured
  end
end
