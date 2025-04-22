class NotifyRecipientsJob < ApplicationJob
  queue_as :default

  def perform(notifiable)
    notifiable.notify_recipients
  end
end
