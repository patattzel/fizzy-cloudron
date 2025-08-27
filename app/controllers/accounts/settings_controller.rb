class Accounts::SettingsController < ApplicationController
  include FilterScoped

  enable_collection_filtering only: :show

  def show
    @account = Account.sole
    @users = User.active
  end
end
