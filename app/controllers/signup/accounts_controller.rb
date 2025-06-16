class Signup::AccountsController < ApplicationController
  require_untenanted_access

  def new
    @signup = Signup.new
  end

  def create
    @signup = Signup.new(signup_params)

    if @signup.process
      redirect_to_account(@signup.account)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
    def signup_params
      params.require(:signup).permit(:full_name, :email_address, :password, :company_name)
    end

    def redirect_to_account(account)
      redirect_to account.signal_account.owner.remote_login_url(proceed_to: root_path),
                  allow_other_host: true
    end
end
