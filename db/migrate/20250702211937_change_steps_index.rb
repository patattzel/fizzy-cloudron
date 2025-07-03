class ChangeStepsIndex < ActiveRecord::Migration[8.1]
  def change
    remove_index :steps, :completed
    add_index :steps, %i[ card_id completed ]
  end
end
