class CreateRollups < ActiveRecord::Migration[8.0]
  def change
    create_table :rollups do |t|
      t.references :bubble, null: false, foreign_key: true

      t.timestamps
    end
  end
end
