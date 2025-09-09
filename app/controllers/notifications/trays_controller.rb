class Notifications::TraysController < ApplicationController
  def show
    @notifications = Current.user.notifications.unread.ordered.limit(100)

    fresh_when @notifications
  end
end
