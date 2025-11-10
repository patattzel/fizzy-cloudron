class AddAutoPopAtToBubbles < ActiveRecord::Migration[8.1]
  def change
    change_table :bubbles do |t|
      t.datetime :auto_pop_at, index: true
    end

    # MySQL uses JOIN syntax for multi-table updates and DATE_ADD for date arithmetic
    execute "
      update bubbles
      join (
        select bubbles.id as bubble_id, coalesce(max(events.created_at), bubbles.created_at) as last_active_at
        from bubbles
        left join events on bubbles.id = events.bubble_id
        group by bubbles.id
      ) as activity on bubbles.id = activity.bubble_id
      set bubbles.auto_pop_at = DATE_ADD(activity.last_active_at, INTERVAL 30 DAY)
    "

    change_column_null :bubbles, :auto_pop_at, false
  end
end
