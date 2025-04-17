class Cards::ReadingsController < ApplicationController
  include CardScoped

  def create
    @notifications = Current.user.notifications.where(card: @card)
    @notifications.each(&:read)
  end
end
