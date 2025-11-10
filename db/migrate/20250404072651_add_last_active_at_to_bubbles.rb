class AddLastActiveAtToBubbles < ActiveRecord::Migration[8.1]
  def change
    add_column :bubbles, :last_active_at, :datetime
    add_index :bubbles, %i[ last_active_at status ]

    # MySQL uses JOIN syntax for multi-table updates
    execute <<~SQL
      update bubbles
      join (
        select bubbles.id as bubble_id, coalesce(max(events.created_at), bubbles.created_at) as last_active_at
        from bubbles
        left join events on bubbles.id = events.bubble_id
        group by bubbles.id
      ) as activity on bubbles.id = activity.bubble_id
      set bubbles.last_active_at = activity.last_active_at
    SQL

    change_column_null :bubbles, :last_active_at, false
  end
end
