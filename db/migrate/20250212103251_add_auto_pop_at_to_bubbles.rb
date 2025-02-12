class AddAutoPopAtToBubbles < ActiveRecord::Migration[8.1]
  def change
    change_table :bubbles do |t|
      t.datetime :auto_pop_at, index: true
    end

    execute "
      update bubbles
        set auto_pop_at = datetime(activity.last_active_at, '+30 days')
        from (
          select bubbles.id as bubble_id, coalesce(max(events.created_at), bubbles.created_at) as last_active_at
          from bubbles
            left join events on bubbles.id = events.bubble_id group by bubbles.id
        ) as activity
        where bubbles.id = activity.bubble_id
    "

    change_column_null :bubbles, :auto_pop_at, false
  end
end
