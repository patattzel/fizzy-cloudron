class CreateCardNotNows < ActiveRecord::Migration[8.1]
  def change
    create_table :card_not_nows do |t|
      t.references :card, null: false, foreign_key: true, index: { unique: true }
      t.timestamps
    end
  end
end
