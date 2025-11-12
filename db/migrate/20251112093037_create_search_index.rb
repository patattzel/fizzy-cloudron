class CreateSearchIndex < ActiveRecord::Migration[8.2]
  def up
    create_table :search_index do |t|
      t.string :searchable_type, null: false
      t.bigint :searchable_id, null: false
      t.bigint :card_id, null: false
      t.bigint :board_id, null: false
      t.string :title
      t.text :content
      t.datetime :created_at, null: false

      t.index [:searchable_type, :searchable_id], unique: true
      t.index [:content, :title], type: :fulltext, name: "index_search_index_on_content_and_title"
    end
  end

  def down
    drop_table :search_index
  end
end
