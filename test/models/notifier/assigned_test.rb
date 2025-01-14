require "test_helper"

class Notifier::AssignedTest < ActiveSupport::TestCase
  test "creates a notification for the assignee" do
    notifications = Notifier.for(events(:logo_assignment_km)).generate

    assert_equal [ users(:kevin) ], notifications.map(&:user)
  end

  test "does not notify for self-assignments" do
    event = EventSummary.last.events.create! action: :assigned,
      creator: users(:kevin),
      particulars: { assignee_ids: [ users(:kevin).id ] }

    assert_no_difference -> { Notification.count } do
      Notifier.for(event).generate
    end
  end

  test "links to the bubble" do
    Notifier.for(events(:logo_assignment_km)).generate

    assert_equal bubbles(:logo), Notification.last.resource
  end
end
