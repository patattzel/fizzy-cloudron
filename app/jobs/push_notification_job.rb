class PushNotificationJob < ApplicationJob
  queue_as :default

  def perform(notification)
    NotificationPusher.new(notification).push
  end
end
