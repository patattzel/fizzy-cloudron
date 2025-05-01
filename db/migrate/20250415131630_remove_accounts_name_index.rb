class RemoveAccountsNameIndex < ActiveRecord::Migration[8.1]
  def change
    remove_index :accounts, :name
  end
end
