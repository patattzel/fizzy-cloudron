class Conversation::Message < ApplicationRecord
  include Pagination, Broadcastable, ClientIdentifiable, Promptable, Respondable

  ALL_EMOJI_REGEX = /\A(\p{Emoji_Presentation}|\p{Extended_Pictographic}|\uFE0F)+\z/u

  has_rich_text :content

  belongs_to :conversation, inverse_of: :messages
  has_one :owner, through: :conversation, source: :user

  enum :role, %w[ user assistant ].index_by(&:itself)

  validates :client_message_id, presence: true

  scope :ordered, -> { order(created_at: :asc, id: :asc) }

  def all_emoji?
    content.to_plain_text.match?(ALL_EMOJI_REGEX)
  end

  def to_partial_path
    "conversations/messages"
  end
end
