require "test_helper"

class Webhook::DelinquencyTrackerTest < ActiveSupport::TestCase
  test "record_delivery_of" do
    tracker = webhook_delinquency_trackers(:active_webhook_tracker)
    webhook = tracker.webhook
    successful_delivery = webhook_deliveries(:successfully_completed)
    failed_delivery = webhook_deliveries(:errored)

    assert_difference -> { tracker.reload.total_count }, +1 do
      assert_no_difference -> { tracker.reload.failed_count } do
        tracker.record_delivery_of(successful_delivery)
      end
    end

    assert_difference -> { tracker.reload.total_count }, +1 do
      assert_difference -> { tracker.reload.failed_count }, +1 do
        tracker.record_delivery_of(failed_delivery)
      end
    end

    travel_to 13.hours.from_now do
      tracker.update!(total_count: 10, failed_count: 5)

      tracker.record_delivery_of(successful_delivery)
      tracker.reload

      assert_equal 0, tracker.total_count
      assert_equal 0, tracker.failed_count
      assert tracker.last_reset_at > 1.minute.ago
    end

    travel_to 26.hours.from_now do
      tracker.update!(total_count: 50, failed_count: 50)
      webhook.activate

      assert_changes -> { webhook.reload.active? }, from: true, to: false do
        tracker.record_delivery_of(failed_delivery)
      end
    end
  end
end
