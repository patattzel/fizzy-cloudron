class Pin < ApplicationRecord
  belongs_to :bubble
  belongs_to :user

  scope :ordered, -> { order(created_at: :desc) }

  after_create_commit -> { broadcast_prepend_later_to [ user, :pins ],
    target: "pins",
    partial: "bubbles/pins/pin"
  }
  after_destroy_commit -> { broadcast_remove_to [ user, :pins ] }
end
