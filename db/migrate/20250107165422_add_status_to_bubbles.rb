class AddStatusToBubbles < ActiveRecord::Migration[8.1]
  def change
    add_column :bubbles, :status, :string, default: "drafted", null: false
  end
end
