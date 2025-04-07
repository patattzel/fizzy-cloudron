class MakeTagTitlesUniquePerAccount < ActiveRecord::Migration[8.1]
  def change
    add_index :tags, [ :account_id, :title ], unique: true
  end
end
