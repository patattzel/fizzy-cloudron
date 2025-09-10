require "test_helper"

class Card::ReadableTest < ActiveSupport::TestCase
  test "read clears events notifications" do
    assert_changes -> { notifications(:logo_published_kevin).reload.read? }, from: false, to: true do
      assert_changes -> { notifications(:logo_assignment_kevin).reload.read? }, from: false, to: true do
        cards(:logo).read_by(users(:kevin))
      end
    end
  end

  test "read clear mentions in the description" do
    assert_changes -> { notifications(:logo_card_david_mention_by_jz).reload.read? }, from: false, to: true do
      cards(:logo).read_by(users(:david))
    end
  end

  test "read clear mentions in comments" do
    assert_changes -> { notifications(:logo_comment_david_mention_by_jz).reload.read? }, from: false, to: true do
      cards(:logo).read_by(users(:david))
    end
  end

  test "read clears notifications from the comments" do
    assert_changes -> { notifications(:layout_commented_kevin).reload.read? }, from: false, to: true do
      cards(:layout).read_by(users(:kevin))
    end
  end

  test "notifications for a given user" do
    # Returns card event notifications
    kevin_notifications = cards(:logo).notifications_for(users(:kevin))
    assert_includes kevin_notifications, notifications(:logo_published_kevin)
    assert_includes kevin_notifications, notifications(:logo_assignment_kevin)

    # Returns comment creation event notifications
    layout_notifications = cards(:layout).notifications_for(users(:kevin))
    assert_includes layout_notifications, notifications(:layout_commented_kevin)

    # Returns card mention notifications
    david_notifications = cards(:logo).notifications_for(users(:david))
    assert_includes david_notifications, notifications(:logo_card_david_mention_by_jz)

    # Returns comment mention notifications
    assert_includes david_notifications, notifications(:logo_comment_david_mention_by_jz)

    # Only returns unread notifications
    notifications(:logo_published_kevin).read
    kevin_notifications_after_read = cards(:logo).notifications_for(users(:kevin))
    assert_not_includes kevin_notifications_after_read, notifications(:logo_published_kevin)
    assert_includes kevin_notifications_after_read, notifications(:logo_assignment_kevin)

    # Does not include notifications from other cards
    other_event = events(:text_published)
    other_notification = users(:kevin).notifications.create!(source: other_event, creator: users(:david))
    logo_notifications = cards(:logo).notifications_for(users(:kevin))
    assert_not_includes logo_notifications, other_notification

    # Does not include notifications for other users
    assert_not_includes kevin_notifications, notifications(:logo_card_david_mention_by_jz)
    assert_not_includes kevin_notifications, notifications(:logo_comment_david_mention_by_jz)
  end
end
