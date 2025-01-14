class NotificationsController < ApplicationController
  def index
    @notifications = Current.user.notifications.unread.ordered.limit(20)
  end
end
