class CreateThreadEntries < ActiveRecord::Migration[8.0]
  def change
    create_table :bubble_thread_entries do |t|
      t.references :thread, null: false, foreign_key: { to_table: :bubble_threads }
      t.references :threadable, polymorphic: true, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
