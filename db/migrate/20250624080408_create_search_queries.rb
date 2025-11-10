class CreateSearchQueries < ActiveRecord::Migration[8.1]
  def change
    create_table :search_queries do |t|
      t.references :user, null: false, foreign_key: true
      t.string :terms, limit: 2000, null: false

      t.timestamps

      # MySQL has a max key length of 3072 bytes. With utf8mb4 (4 bytes/char),
      # we can only index 768 characters. Using a 255 character prefix is
      # sufficient for search query lookups while staying well under the limit.
      t.index "user_id, terms(255)", name: "index_search_queries_on_user_id_and_terms"
    end
  end
end
