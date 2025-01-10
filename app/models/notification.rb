class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :creator, class_name: 'User'
  belongs_to :resource, polymorphic: true

  scope :unread, -> { where(read: false) }
  scope :ordered, -> { order(read: :desc, created_at: :desc) }
end
