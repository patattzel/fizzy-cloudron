class RenameBucketViewsToFilters < ActiveRecord::Migration[8.0]
  def change
    rename_table :bucket_views, :filters

    remove_index :filters, %i[ bucket_id creator_id filters_hash ], unique: true
    remove_index :filters, :creator_id
    remove_column :filters, :filters_hash, :string

    remove_reference :filters, :bucket

    rename_column :filters, :filters, :params

    add_column :filters, :fields, :json, null: false, default: -> { '(JSON_OBJECT())' }

    # MySQL doesn't support direct indexing of JSON columns. Create a generated
    # hash column for the params JSON data to enforce uniqueness.
    add_column :filters, :params_hash, :string, limit: 64, as: "SHA2(params, 256)", stored: true
    add_index :filters, %i[ creator_id params_hash ], unique: true
  end
end
