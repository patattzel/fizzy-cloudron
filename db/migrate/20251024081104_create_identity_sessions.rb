class CreateIdentitySessions < ActiveRecord::Migration[8.2]
  def change
    create_table "sessions", force: :cascade do |t|
      t.references "identity", null: false, foreign_key: true
      t.string "ip_address"
      t.string "user_agent"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end
  end
end
