class AddLastActiveAtToBubbles < ActiveRecord::Migration[8.1]
  def change
    add_column :bubbles, :last_active_at, :datetime
    add_index :bubbles, %i[ last_active_at status ]
  end
end
