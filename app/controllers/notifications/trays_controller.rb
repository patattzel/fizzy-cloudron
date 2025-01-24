class Notifications::TraysController < ApplicationController
  def show
    @notifications = Current.user.notifications.unread.ordered.limit(20)
  end
end
