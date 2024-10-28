require "test_helper"

class EventSummaryTest < ActiveSupport::TestCase
  test "body" do
    assert_equal "Added by David 7 days ago. Assigned to JZ 7 days ago. David +1.", event_summaries(:logo_initial_activity).body
    assert_equal "Assigned to Kevin 1 day ago. Kevin +2 and JZ +1.", event_summaries(:logo_second_activity).body
    assert_equal "JZ +1.", event_summaries(:logo_third_activity).body
    assert_equal "Added by Kevin 7 days ago.", event_summaries(:text_initial_activity).body
  end
end
