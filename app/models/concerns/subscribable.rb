module Subscribable
  extend ActiveSupport::Concern

  TYPES = %w[ Bucket ]

  included do
    has_many :subscriptions, as: :subscribable, dependent: :destroy
    has_many :subscribers, through: :subscriptions, source: :user
  end

  def subscribe(user)
    subscriptions.create_or_find_by!(user: user)
  end
end
