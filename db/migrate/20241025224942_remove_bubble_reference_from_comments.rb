class RemoveBubbleReferenceFromComments < ActiveRecord::Migration[8.0]
  def change
    remove_column :comments, :bubble_id, :references, null: false, index: false
  end
end
