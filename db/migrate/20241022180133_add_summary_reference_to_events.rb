class AddSummaryReferenceToEvents < ActiveRecord::Migration[8.0]
  def change
    add_reference :events, :summary, foreign_key: { to_table: :event_summaries }, index: false
    remove_index :events, %i[ bubble_id action ]
    add_index :events, :bubble_id
    add_index :events, %i[ summary_id action ]
  end
end
