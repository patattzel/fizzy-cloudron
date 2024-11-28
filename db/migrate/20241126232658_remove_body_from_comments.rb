class RemoveBodyFromComments < ActiveRecord::Migration[8.0]
  def change
    remove_column :comments, :body, :text, null: false
  end
end
