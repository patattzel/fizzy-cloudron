class Notification::Bundle::DeliverAllJob < ApplicationJob
  queue_as :backend

  def perform
    Notification::Bundle.deliver_all
  end
end
