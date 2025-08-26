class Notification::Bundle::DeliverJob < ApplicationJob
  def perform(bundle)
    bundle.deliver
  end
end
