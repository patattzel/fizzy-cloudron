class Cards::ReadingsController < ApplicationController
  include CardScoped

  def create
    @notifications = Current.user.notifications.where(source: @card.events)
    @notifications.each(&:read)
  end
end
