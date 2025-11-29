class SignupsController < ApplicationController
  disallow_account_scope
  allow_unauthenticated_access
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_signup_path, alert: "Try again later." }

  layout "public"

  def new
    @signup = Signup.new
  end

  def create
    if Current.identity
      Signup.new(signup_params).create_identity
      redirect_to session_magic_link_path
    else
      redirect_to new_signup_completion_path
    end
  end

  private
    def signup_params
      params.expect signup: :email_address
    end
end
