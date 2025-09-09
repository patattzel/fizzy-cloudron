module Event::WebhookDeliverable
  extend ActiveSupport::Concern

  included do
    has_many :webhook_deliveries, class_name: "Webhook::Delivery", dependent: :delete_all
  end
end
