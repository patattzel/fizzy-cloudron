class CreateNotifications < ActiveRecord::Migration[8.1]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true
      t.references :bubble, null: false, foreign_key: true
      t.references :resource, null: false, polymorphic: true, index: true
      t.boolean :read, default: false, null: false

      t.timestamps

      t.index %i[ user_id read created_at ], order: { read: :desc, created_at: :desc }
    end
  end
end
