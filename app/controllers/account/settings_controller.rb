class Account::SettingsController < ApplicationController
  def show
    @account = Account.sole
    @users = User.active.alphabetically
  end

  def update
    if Current.user.can_administer?
      Account.sole.update!(account_params)
      redirect_to account_settings_path
    else
      head :forbidden
    end
  end

  private
    def account_params
      params.expect account: %i[ name ]
    end
end
