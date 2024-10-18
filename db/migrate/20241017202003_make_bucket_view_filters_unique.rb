class MakeBucketViewFiltersUnique < ActiveRecord::Migration[8.0]
  def change
    add_index :bucket_views, %i[ bucket_id creator_id filters ], unique: true
    remove_index :bucket_views, :bucket_id
  end
end
