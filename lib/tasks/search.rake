namespace :search do
  desc "Reindex all cards and comments in the search index"
  task reindex: :environment do
    puts "Clearing search records..."
    if ActiveRecord::Base.connection.adapter_name == "SQLite"
      ActiveRecord::Base.connection.execute("DELETE FROM search_records")
      ActiveRecord::Base.connection.execute("DELETE FROM search_records_fts")
    else
      Search::Record::Trilogy::SHARD_COUNT.times do |shard_id|
        ActiveRecord::Base.connection.execute("DELETE FROM search_records_#{shard_id}")
      end
    end

    puts "Reindexing cards..."
    Card.find_each do |card|
      Current.account = card.account
      card.reindex
    end

    puts "Reindexing comments..."
    Comment.find_each do |comment|
      Current.account = comment.account
      comment.reindex
    end

    puts "Done! Reindexed #{Card.count} cards and #{Comment.count} comments."
  end
end
