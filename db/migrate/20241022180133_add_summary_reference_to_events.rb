class AddSummaryReferenceToEvents < ActiveRecord::Migration[8.0]
  def change
    add_reference :events, :summary, foreign_key: { to_table: :event_summaries }, index: false
    add_index :events, %i[ summary_id action ]

    remove_index :events, %i[ bubble_id action ]
    remove_column :events, :bubble_id, :references, null: false, index: false
  end
end
