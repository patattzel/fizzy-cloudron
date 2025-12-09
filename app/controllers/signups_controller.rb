class SignupsController < ApplicationController
  disallow_account_scope
  allow_unauthenticated_access
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_signup_path, alert: "Try again later." }
  before_action :redirect_authenticated_user
  before_action :prevent_signup_when_users_exist, if: -> { single_tenant? && User.any? }

  layout "public"

  def new
    @signup = Signup.new
  end

  def create
    signup = Signup.new(signup_params)
    if signup.valid?(:identity_creation)
      redirect_to_session_magic_link signup.create_identity
    else
      head :unprocessable_entity
    end
  end

  private
    def redirect_authenticated_user
      redirect_to new_signup_completion_path if authenticated?
    end

    def signup_params
      params.expect signup: :email_address
    end

    def prevent_signup_when_users_exist
      redirect_to new_session_url, alert: "Your account hasn’t been set up yet. Please request an invitation from one of your coworkers."
    end
end
