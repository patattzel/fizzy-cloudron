class Notification::Bundle::DeliverAllJob < ApplicationJob
  def perform
    Notification::Bundle.deliver_all
  end
end
