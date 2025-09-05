class DropEventActivitySummaries < ActiveRecord::Migration[8.1]
  def change
    drop_table :event_activity_summaries
  end
end
