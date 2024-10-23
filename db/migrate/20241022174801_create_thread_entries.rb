class CreateThreadEntries < ActiveRecord::Migration[8.0]
  def change
    create_table :thread_entries do |t|
      t.references :bubble, null: false, foreign_key: true
      t.references :threadable, polymorphic: true, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
