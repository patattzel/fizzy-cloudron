require "test_helper"

class Notifier::CommentedTest < ActiveSupport::TestCase
  test "creates a notification for each recipient" do
    assert_difference -> { Notification.count }, 2 do
      assert_difference -> { users(:kevin).notifications.count }, 1 do
        assert_difference -> { users(:jz).notifications.count }, 1 do
          Notifier.for(events(:layout_commented)).generate
        end
      end
    end
  end

  test "links to the bubble" do
    Notifier.for(events(:layout_commented)).generate

    assert_equal comments(:layout_overflowing_david), Notification.last.resource
  end
end
