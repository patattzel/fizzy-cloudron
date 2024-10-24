class AddRollupReferenceToEvents < ActiveRecord::Migration[8.0]
  def change
    add_reference :events, :rollup, foreign_key: { to_table: :event_rollups }
  end
end
