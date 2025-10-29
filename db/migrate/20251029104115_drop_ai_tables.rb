class DropAiTables < ActiveRecord::Migration[8.2]
  def change
    drop_table :user_weekly_summaries
    drop_table :period_summaries
    drop_table :search_embeddings
  end
end
