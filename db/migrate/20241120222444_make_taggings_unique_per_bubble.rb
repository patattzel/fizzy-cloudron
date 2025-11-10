class MakeTaggingsUniquePerBubble < ActiveRecord::Migration[8.0]
  def change
    # Add the composite index first, then remove the old single-column index.
    # MySQL requires an index for foreign key constraints, so we need the new
    # composite index in place before removing the old one.
    add_index :taggings, %i[ bubble_id tag_id ], unique: true
    remove_index :taggings, :bubble_id
  end
end
