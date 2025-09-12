class Webhook::DelinquencyTracker < ApplicationRecord
  LOW_VOLUME_TRESHOLD = 10
  RESET_INTERVAL = 1.hour

  belongs_to :webhook

  before_validation { self.last_reset_at ||= Time.current }

  def record_delivery_of(delivery)
    if delivery.failed? && high_volume? && reset_due?
      webhook.deactivate if delinquent?
      reset
    else
      increment!(:total_count)
      increment!(:failed_count) if delivery.failed?
    end
  end

  private
    def high_volume?
      total_count > LOW_VOLUME_TRESHOLD
    end

    def delinquent?
      failed_count == total_count
    end

    def reset_due?
      last_reset_at.before?(RESET_INTERVAL.ago)
    end

    def reset
      update_columns total_count: 0, failed_count: 0, last_reset_at: Time.current
    end
end
