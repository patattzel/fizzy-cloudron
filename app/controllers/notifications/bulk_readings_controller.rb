class Notifications::BulkReadingsController < ApplicationController
  def create
    Current.user.notifications.unread.read_all
  end
end
