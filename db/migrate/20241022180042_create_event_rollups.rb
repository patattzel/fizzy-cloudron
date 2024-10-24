class CreateEventRollups < ActiveRecord::Migration[8.0]
  def change
    create_table :event_rollups do |t|
      t.timestamps
    end
  end
end
