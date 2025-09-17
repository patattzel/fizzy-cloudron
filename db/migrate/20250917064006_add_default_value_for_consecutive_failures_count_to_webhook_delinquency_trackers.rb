class AddDefaultValueForConsecutiveFailuresCountToWebhookDelinquencyTrackers < ActiveRecord::Migration[8.1]
  def change
    change_column_default :webhook_delinquency_trackers, :consecutive_failures_count, from: nil, to: 0
  end
end
