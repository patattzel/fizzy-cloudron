class MakeBucketViewFiltersUnique < ActiveRecord::Migration[8.0]
  def change
    # MySQL doesn't support direct indexing of JSON columns. To ensure uniqueness
    # of the filters JSON content, we create a generated column that stores a SHA2
    # hash of the JSON data. This allows us to enforce that each creator can only
    # have one view per bucket with the same filter configuration.
    add_column :bucket_views, :filters_hash, :string, limit: 64, as: "SHA2(filters, 256)", stored: true
    add_index :bucket_views, %i[ bucket_id creator_id filters_hash ], unique: true
    remove_index :bucket_views, :bucket_id
  end
end
