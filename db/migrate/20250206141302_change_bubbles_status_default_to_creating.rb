class ChangeBubblesStatusDefaultToCreating < ActiveRecord::Migration[8.1]
  def change
    change_column_default :bubbles, :status, :creating
  end
end
