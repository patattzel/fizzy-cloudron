class CreateEventSummaries < ActiveRecord::Migration[8.0]
  def change
    create_table :event_summaries do |t|
      t.timestamps
    end
  end
end
