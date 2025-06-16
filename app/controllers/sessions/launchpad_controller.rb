class Sessions::LaunchpadController < ApplicationController
  require_unauthenticated_access

  def show
    if user = Current.account.signal_account.authenticate(sig: params[:sig]).try(:peer)
      start_new_session_for user
      redirect_to after_authentication_url
    else
      render plain: "Authentication failed. This is probably a bug.", status: :unauthorized
    end
  end
end
