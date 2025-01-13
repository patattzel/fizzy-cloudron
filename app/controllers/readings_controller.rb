class ReadingsController < ApplicationController
  include BubbleScoped, BucketScoped

  def create
    @notifications = Current.user.notifications.where(bubble: @bubble)
    @notifications.update(read: true)
  end
end
