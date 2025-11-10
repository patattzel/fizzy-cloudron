class AssociateEventsWithBubbles < ActiveRecord::Migration[8.1]
  def change
    change_table :events do |t|
      t.references :bubble, foreign_key: true
    end

    # MySQL uses JOIN syntax for multi-table updates, not FROM clause
    execute "
      update events
      join event_summaries es on events.summary_id = es.id
      join messages m on m.messageable_type = 'EventSummary' and m.messageable_id = es.id
      set events.bubble_id = m.bubble_id
    "

    change_column_null :events, :bubble_id, false
  end
end
