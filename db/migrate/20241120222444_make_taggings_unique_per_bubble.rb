class MakeTaggingsUniquePerBubble < ActiveRecord::Migration[8.0]
  def change
    remove_index :taggings, :bubble_id
    add_index :taggings, %i[ bubble_id tag_id ], unique: true
  end
end
