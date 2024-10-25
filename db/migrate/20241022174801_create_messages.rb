class CreateMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :messages do |t|
      t.references :bubble, null: false, foreign_key: true
      t.references :messageable, polymorphic: true, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
