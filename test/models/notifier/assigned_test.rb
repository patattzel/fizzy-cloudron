require "test_helper"

class Notifier::AssignedTest < ActiveSupport::TestCase
  test "generate creates a notification for each recipient" do
    assert_difference -> { Notification.count }, 1 do
      assert_difference -> { users(:kevin).notifications.count }, 1 do
        Notifier.for(events(:logo_assignment_km)).generate
      end
    end
  end

  test "generate does not notify for self-assignments" do
    event = EventSummary.last.events.create! action: :assigned, creator: users(:kevin), particulars: { assignee_ids: [ users(:kevin).id ] }

    assert_no_difference -> { Notification.count } do
      Notifier.for(event).generate
    end
  end

  test "generate populates the notification details" do
    Notifier.for(events(:logo_assignment_km)).generate

    assert_equal "David assigned you: The logo isn't big enough", Notification.last.body
  end
end
