class AddIndexToSortPopsByRecency < ActiveRecord::Migration[8.1]
  def change
    add_index :pops, %i[ bubble_id created_at ]
  end
end
