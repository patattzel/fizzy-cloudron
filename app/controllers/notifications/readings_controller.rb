class Notifications::ReadingsController < ApplicationController
  def create
    @notification = Current.user.notifications.find(params[:id])
    @notification.read
  end

  def create_all
    Current.user.notifications.unread.read_all
    respond_to do |format|
      format.html { redirect_to notifications_path }
      format.turbo_stream { } # No action needed, readings will have been broadcast
    end
  end
end
