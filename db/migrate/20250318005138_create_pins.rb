class CreatePins < ActiveRecord::Migration[7.0]
  def change
    create_table :pins do |t|
      t.references :bubble, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end

    add_index :pins, [ :bubble_id, :user_id ], unique: true
  end
end
