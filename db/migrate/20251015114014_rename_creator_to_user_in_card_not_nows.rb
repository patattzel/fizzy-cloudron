class RenameCreatorToUserInCardNotNows < ActiveRecord::Migration[8.1]
  def change
    rename_column :card_not_nows, :creator_id, :user_id
  end
end
