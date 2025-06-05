class CreateEntropyConfigurations < ActiveRecord::Migration[8.1]
  def change
    create_table :entropy_configurations do |t|
      t.references :container, polymorphic: true, null: false, index: { unique: true }

      t.bigint :auto_close_period, null: false, default: 30.days.to_i
      t.bigint :auto_reconsider_period, null: false, default: 30.days.to_i

      t.timestamps

      t.index %i[ container_type container_id auto_close_period ]
      t.index %i[ container_type container_id auto_reconsider_period ]
    end
  end
end
