class Reaction < ApplicationRecord
  belongs_to :comment, touch: true
  belongs_to :reacter, class_name: "User", default: -> { Current.user }

  scope :ordered, -> { order(:created_at) }

  after_create :register_card_activity

  def all_emoji?
    content.match? /\A(\p{Emoji_Presentation}|\p{Extended_Pictographic}|\uFE0F)+\z/u
  end

  private
    def register_card_activity
      comment.card.touch_last_active_at
    end
end
