class Webhook::CleanupDeliveriesJob < ApplicationJob
  def perform
    Webhook::Delivery.cleanup
  end
end
