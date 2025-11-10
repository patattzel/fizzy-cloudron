class CreateCommands < ActiveRecord::Migration[8.1]
  def change
    create_table :commands do |t|
      t.references :user, null: false, foreign_key: true, index: true
      t.string :type
      t.column :data, :json, default: -> { '(JSON_OBJECT())' }

      t.timestamps

      t.index %i[ user_id created_at ]
    end
  end
end
