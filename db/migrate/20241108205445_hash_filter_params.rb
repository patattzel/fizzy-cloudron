class HashFilterParams < ActiveRecord::Migration[8.0]
  def change
    remove_index :filters, %i[ creator_id params_hash ], unique: true
    remove_column :filters, :params_hash
    remove_column :filters, :params

    add_column :filters, :params_digest, :string, null: false
    add_index :filters, %i[ creator_id params_digest ], unique: true
  end
end
