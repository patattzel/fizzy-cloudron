class Notifications::ReadingsController < ApplicationController
  def create
    @notification = Current.user.notifications.find(params[:notification_id])
    @notification.read
  end

  def destroy
    @notification = Current.user.notifications.find(params[:notification_id])
    @notification.unread
  end
end
