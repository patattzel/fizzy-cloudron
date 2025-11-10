class CreateSearchIndexes < ActiveRecord::Migration[8.0]
  def change
    # # TODO:PLANB: need to replace SQLite FTS
    # create_virtual_table :bubbles_search_index, "fts5", [ "title" ]
    # create_virtual_table :comments_search_index, "fts5", [ "body" ]
  end
end
