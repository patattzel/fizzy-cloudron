class Message < ApplicationRecord
  include Mentions

  belongs_to :card, touch: true

  delegated_type :messageable, types: Messageable::TYPES, inverse_of: :message, dependent: :destroy

  scope :chronologically, -> { order created_at: :asc, id: :desc }

  delegate :collection, to: :card
end
