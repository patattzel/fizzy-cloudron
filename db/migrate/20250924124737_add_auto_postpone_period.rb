class AddAutoPostponePeriod < ActiveRecord::Migration[8.1]
  def change
    add_column :entropy_configurations, :auto_postpone_period, :bigint, default: 30.days.to_i, null: false
    add_index :entropy_configurations, [:container_type, :container_id, :auto_postpone_period]

    execute <<-SQL
      UPDATE entropy_configurations
      SET auto_postpone_period = auto_close_period
    SQL

    remove_index :entropy_configurations, name: "idx_on_container_type_container_id_auto_close_perio_74dc880875"
    remove_index :entropy_configurations, name: "idx_on_container_type_container_id_auto_reconsider__583aaddbea"

    remove_column :entropy_configurations, :auto_close_period, :bigint
    remove_column :entropy_configurations, :auto_reconsider_period, :bigint
  end
end
