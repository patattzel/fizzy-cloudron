class Comment < ApplicationRecord
  include Eventable, Mentions, Messageable, Searchable

  belongs_to :creator, class_name: "User", default: -> { Current.user }
  has_many :reactions, dependent: :delete_all

  has_markdown :body
  searchable_by :body_plain_text, using: :comments_search_index, as: :body

  # FIXME: Not a fan of this. Think all references to comment should come directly from the message.
  scope :belonging_to_card, ->(card) { joins(:message).where(messages: { card_id: card.id }) }

  after_create_commit :watch_card_by_creator

  delegate :watch_by, to: :card

  def to_partial_path
    "cards/#{super}"
  end

  private
    def watch_card_by_creator
      card.watch_by creator
    end
end
