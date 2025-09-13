require "test_helper"

class User::HighlightsTest < ActiveSupport::TestCase
  # Skipping when locally authenticating because the VCR cassettes would need to be re-recorded.
  unless Rails.application.config.x.local_authentication
    include VcrTestHelper

    setup do
      @user = users(:david)
      travel_to 1.week.ago + 2.days
    end

    test "generate weekly highlights" do
      stub_const(PeriodHighlights::Period, :MIN_EVENTS_TO_BE_INTERESTING, 3) do
        period_highlights = assert_difference -> { PeriodHighlights.count }, 1 do
          @user.generate_weekly_highlights
        end

        assert_match /logo/i, period_highlights.to_html
      end
    end

    test "don't generate highlights for existing periods" do
      stub_const(PeriodHighlights::Period, :MIN_EVENTS_TO_BE_INTERESTING, 3) do
        new_period_highlights = @user.generate_weekly_highlights
        assert_not_nil new_period_highlights

        existing_period_highlights = assert_no_difference -> { PeriodHighlights.count } do
          @user.generate_weekly_highlights
        end

        assert_equal new_period_highlights, existing_period_highlights
      end
    end
  end
end
