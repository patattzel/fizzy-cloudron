require "test_helper"

class Notifier::CommentedTest < ActiveSupport::TestCase
  test "creates a notification for each recipient" do
    notifications = Notifier.for(events(:layout_commented)).generate

    assert_equal users(:kevin, :jz).sort, notifications.map(&:user).sort
  end

  test "links to the bubble" do
    Notifier.for(events(:layout_commented)).generate

    assert_equal comments(:layout_overflowing_david), Notification.last.resource
  end
end
