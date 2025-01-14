require "test_helper"

class Notifier::PoppedTest < ActiveSupport::TestCase
  test "creates a notification for each recipient" do
    assert_difference -> { Notification.count }, 2 do
      assert_difference -> { users(:david).notifications.count }, 1 do
        assert_difference -> { users(:jz).notifications.count }, 1 do
          Notifier.for(events(:shipping_popped)).generate
        end
      end
    end
  end

  test "links to the bubble" do
    Notifier.for(events(:shipping_popped)).generate

    assert_equal bubbles(:shipping), Notification.last.resource
  end
end
