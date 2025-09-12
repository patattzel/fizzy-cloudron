class ChangeDefaultInvolvementToAccessOnly < ActiveRecord::Migration[8.1]
  def change
    change_column_default :accesses, :involvement, "access_only"
  end
end
