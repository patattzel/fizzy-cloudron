class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :creator, class_name: "User"
  belongs_to :bubble
  belongs_to :resource, polymorphic: true

  scope :unread, -> { where(read: false) }
  scope :ordered, -> { order(read: :desc, created_at: :desc) }

  broadcasts_to ->(notification) { [ notification.user, :notifications ] }, inserts_by: :prepend
end
