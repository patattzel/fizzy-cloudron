# frozen_string_literal: true

class CreateSolidCacheTables < ActiveRecord::Migration[8.0]
  def change
    return if table_exists?(:solid_cache_entries)

    create_table "solid_cache_entries", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci" do |t|
      t.integer "byte_size", null: false
      t.datetime "created_at", null: false
      t.binary "key", limit: 1024, null: false
      t.bigint "key_hash", null: false
      t.binary "value", size: :long, null: false
      t.index ["byte_size"], name: "index_solid_cache_entries_on_byte_size"
      t.index ["key_hash", "byte_size"], name: "index_solid_cache_entries_on_key_hash_and_byte_size"
      t.index ["key_hash"], name: "index_solid_cache_entries_on_key_hash", unique: true
    end
  end
end
