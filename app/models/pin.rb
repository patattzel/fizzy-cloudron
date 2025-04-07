class Pin < ApplicationRecord
  belongs_to :bubble
  belongs_to :user

  scope :ordered, -> { order(created_at: :desc) }
end
