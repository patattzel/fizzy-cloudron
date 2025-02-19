class CreateReactions < ActiveRecord::Migration[8.1]
  def change
    create_table :reactions do |t|
      t.integer :comment_id, null: false
      t.integer :reacter_id, null: false
      t.string :content, limit: 16, null: false

      t.timestamps
    end

    add_index :reactions, :comment_id
    add_index :reactions, :reacter_id
  end
end
