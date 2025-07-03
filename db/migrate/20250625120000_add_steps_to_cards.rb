class AddStepsToCards < ActiveRecord::Migration[8.1]
  def change
    create_table :steps do |t|
      t.references :card, null: false, foreign_key: true
      t.text :content, null: false
      t.boolean :completed, default: false, null: false

      t.timestamps
    end

    add_index :steps, :completed
  end
end
