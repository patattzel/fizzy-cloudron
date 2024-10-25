class Message < ApplicationRecord
  belongs_to :bubble, touch: true

  delegated_type :messageable, types: Messageable::TYPES, inverse_of: :message, dependent: :destroy

  after_touch -> { bubble.touch }

  scope :chronologically, -> { order created_at: :asc, id: :desc }
end
