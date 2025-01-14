require "test_helper"

class Notifier::PoppedTest < ActiveSupport::TestCase
  test "creates a notification for each recipient" do
    notifications = Notifier.for(events(:shipping_popped)).generate

    assert_equal users(:david, :jz).sort, notifications.map(&:user).sort
  end

  test "links to the bubble" do
    Notifier.for(events(:shipping_popped)).generate

    assert_equal bubbles(:shipping), Notification.last.resource
  end
end
