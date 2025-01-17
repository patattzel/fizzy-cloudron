class AssociateEventsWithBubbles < ActiveRecord::Migration[8.1]
  def change
    change_table :events do |t|
      t.references :bubble, foreign_key: true
    end

    execute "
      update events
      set bubble_id = m.bubble_id
      from event_summaries es
        join messages m on m.messageable_type = 'EventSummary' and m.messageable_id = es.id
      where events.summary_id = es.id
    "

    change_column_null :events, :bubble_id, false
  end
end
