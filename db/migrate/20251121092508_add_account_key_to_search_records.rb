class AddAccountKeyToSearchRecords < ActiveRecord::Migration[8.2]
  def up
    16.times do |shard_id|
      table_name = "search_records_#{shard_id}"

      # Add account_key column
      add_column table_name, :account_key, :string, null: false, default: ""

      # Backfill existing records with account_key
      execute <<-SQL
        UPDATE #{table_name}
        SET account_key = CONCAT('account', account_id)
      SQL

      # Create new fulltext index including account_key
      add_index table_name, [:account_key, :content, :title], type: :fulltext

      # Drop existing fulltext index
      remove_index table_name, column: [:content, :title], type: :fulltext
    end
  end

  def down
    16.times do |shard_id|
      table_name = "search_records_#{shard_id}"

      # Drop new fulltext index
      remove_index table_name, column: [:account_key, :content, :title], type: :fulltext

      # Restore original fulltext index
      add_index table_name, [:content, :title], type: :fulltext

      # Remove account_key column
      remove_column table_name, :account_key
    end
  end
end
