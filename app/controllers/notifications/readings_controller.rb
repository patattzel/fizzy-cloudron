class Notifications::ReadingsController < ApplicationController
  def create
    @notification = Current.user.notifications.find(params[:id])
    @notification.update!(read_at: Time.current)
  end

  def create_all
    Current.user.notifications.unread.read_all

    set_page_and_extract_portion_from Current.user.notifications.read.ordered if request.format.turbo_stream?

    Turbo::StreamsChannel.broadcast_update_to [ Current.user, :notifications ], target: "notifications", html: ""
  end
end
