class AddSummaryReferenceToEvents < ActiveRecord::Migration[8.0]
  def change
    add_reference :events, :summary, foreign_key: { to_table: :event_summaries }
  end
end
