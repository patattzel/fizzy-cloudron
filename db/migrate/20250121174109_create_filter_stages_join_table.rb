class CreateFilterStagesJoinTable < ActiveRecord::Migration[8.1]
  def change
    create_join_table :filters, :stages do |t|
      t.index :filter_id
      t.index :stage_id
    end
  end
end
