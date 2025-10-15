class RemoveNullConstraintFromCardNotNowsUser < ActiveRecord::Migration[8.1]
  def change
    change_column_null :card_not_nows, :user_id, true
  end
end
