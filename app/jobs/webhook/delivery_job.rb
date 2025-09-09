class Webhook::DeliveryJob < ApplicationJob
  queue_as :webhooks
  limits_concurrency to: 1, key: ->(delivery) { delivery.webhook_id }

  def perform(delivery)
    delivery.deliver
  end
end
