class CreateBubbleThread < ActiveRecord::Migration[8.0]
  def change
    create_table :bubble_threads do |t|
      t.references :bubble, null: false, foreign_key: true

      t.timestamps
    end
  end
end
