class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :event
  belongs_to :bubble
  belongs_to :resource, polymorphic: true

  scope :unread, -> { where(read: false) }
  scope :ordered, -> { order(read: :desc, created_at: :desc) }

  delegate :creator, to: :event

  broadcasts_to ->(notification) { [ notification.user, :notifications ] }, inserts_by: :prepend
end
