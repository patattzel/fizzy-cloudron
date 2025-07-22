require "test_helper"

class Event::ActivitySummaryTest < ActiveSupport::TestCase
  include VcrTestHelper

  setup do
    @events = Event.limit(3)
  end

  test "create summaries only once for a given set of events" do
    event = assert_difference -> { Event::ActivitySummary.count }, +1 do
      Event::ActivitySummary.create_for(@events)
    end

    assert_no_difference -> { Event::ActivitySummary.count } do
      assert_equal event, Event::ActivitySummary.create_for(@events)
      assert_equal event, Event::ActivitySummary.create_for(@events.order("action desc").where(id: events.ids)) # order does not matter
    end
  end

  test "fetching a existing summary" do
    assert_nil Event::ActivitySummary.for(@events)

    event = Event::ActivitySummary.create_for(@events)
    assert_equal event, Event::ActivitySummary.for(@events)
  end
end
