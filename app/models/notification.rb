class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :bubble

  scope :unread, -> { where.not(:read) }
  scope :ordered, -> { order(created_at: :desc) }
end
