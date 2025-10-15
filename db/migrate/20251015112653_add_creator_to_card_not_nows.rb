class AddCreatorToCardNotNows < ActiveRecord::Migration[8.1]
  def change
    add_reference :card_not_nows, :creator, null: false, foreign_key: { to_table: :users }
  end
end
