class AddTimezoneNameToUserSettings < ActiveRecord::Migration[8.1]
  def change
    add_column :user_settings, :timezone_name, :string
  end
end
