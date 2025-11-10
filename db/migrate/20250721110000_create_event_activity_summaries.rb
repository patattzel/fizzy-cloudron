class CreateEventActivitySummaries < ActiveRecord::Migration[8.1]
  def change
    create_table :event_activity_summaries do |t|
      t.string :key, null: false
      t.text :contents, null: false
      t.column :data, :json, default: -> { '(JSON_OBJECT())' }

      t.timestamps

      t.index [ :key ], unique: true
    end
  end
end
