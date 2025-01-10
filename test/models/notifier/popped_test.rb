require "test_helper"

class Notifier::PoppedTest < ActiveSupport::TestCase
  test "generate populates the notification details" do
    Notifier.for(events(:shipping_popped)).generate

    assert_equal "popped: We need to ship the app", Notification.last.body
  end
end
