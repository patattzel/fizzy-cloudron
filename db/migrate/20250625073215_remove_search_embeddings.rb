class RemoveSearchEmbeddings < ActiveRecord::Migration[8.1]
  def change
    drop_table :search_embeddings
  end
end
