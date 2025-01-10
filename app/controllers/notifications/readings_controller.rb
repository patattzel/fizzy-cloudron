class Notifications::ReadingsController < ApplicationController
  def create
    Current.user.notifications.find(params[:notification_id]).update!(read: true)
  end
end
