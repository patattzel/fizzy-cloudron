require "test_helper"

class Notifier::CreatedTest < ActiveSupport::TestCase
  test "generate creates a notification for each recipient" do
    assert_difference -> { Notification.count }, 2 do
      assert_difference -> { users(:kevin).notifications.count }, 1 do
        assert_difference -> { users(:jz).notifications.count }, 1 do
          Notifier.for(events(:logo_created)).generate
        end
      end
    end
  end

  test "generate populates the notification details" do
    Notifier.for(events(:logo_created)).generate

    assert_equal "created: The logo isn't big enough", Notification.last.body
  end
end
