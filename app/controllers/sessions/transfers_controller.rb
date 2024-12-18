class Sessions::TransfersController < ApplicationController
  require_unauthenticated_access

  def show
  end

  def update
    if user = User.active.find_by_transfer_id(params[:id])
      start_new_session_for user
      redirect_to root_path
    else
      head :bad_request
    end
  end
end
