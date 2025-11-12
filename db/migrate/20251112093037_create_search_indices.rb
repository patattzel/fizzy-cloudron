class CreateSearchIndex < ActiveRecord::Migration[8.2]
  def up
    16.times do |i|
      create_table "search_index_#{i}".to_sym do |t|
        t.string :searchable_type, null: false
        t.bigint :searchable_id, null: false
        t.bigint :card_id, null: false
        t.bigint :board_id, null: false
        t.string :title
        t.text :content
        t.datetime :created_at, null: false

        t.index [:searchable_type, :searchable_id], unique: true, name: "idx_si#{i}_type_id"
        t.index [:content, :title], type: :fulltext, name: "idx_si#{i}_fulltext"
      end
    end
  end

  def down
    16.times do |i|
      drop_table "search_index_#{i}".to_sym
    end
  end
end
