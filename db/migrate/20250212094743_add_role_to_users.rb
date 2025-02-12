class AddRoleToUsers < ActiveRecord::Migration[8.1]
  def change
    change_table :users do |t|
      t.string :role, null: false, default: :member, index: true
    end

    change_column_null :users, :email_address, true
    change_column_null :users, :password_digest, true
  end
end
