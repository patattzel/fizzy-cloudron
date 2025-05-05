class CreateCommands < ActiveRecord::Migration[8.1]
  def change
    create_table :commands do |t|
      t.references :user, null: false, foreign_key: true, index: true
      t.json :data, default: {}

      t.timestamps
    end
  end
end
