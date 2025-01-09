class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :bubble

  scope :unread, -> { where(read: false) }
  scope :ordered, -> { order(read: :desc, created_at: :desc) }
end
