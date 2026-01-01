class Signups::CompletionsController < ApplicationController
  layout "public"

  disallow_account_scope
  before_action :ensure_signups_allowed

  def new
    @signup = Signup.new(identity: Current.identity)
  end

  def create
    @signup = Signup.new(signup_params)

    if @signup.complete
      flash[:welcome_letter] = true
      redirect_to landing_url(script_name: @signup.account.slug)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
    def ensure_signups_allowed
      head :not_found unless SignupToggle.allowed?
    end

    def signup_params
      params.expect(signup: %i[ full_name ]).with_defaults(identity: Current.identity)
    end
end
