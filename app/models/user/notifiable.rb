module User::Notifiable
  extend ActiveSupport::Concern

  included do
    has_many :notifications, dependent: :destroy
    has_many :notification_bundles, class_name: "Notification::Bundle", dependent: :destroy
  end

  def bundle(notification)
    transaction do
      find_or_create_pending_bundle_for(notification).add(notification)
    end
  end

  private
    def find_or_create_pending_bundle_for(notification)
      notification_bundles.pending.last || notification_bundles.create!(starts_at: notification.created_at)
    end
end
