class Cards::WatchesController < ApplicationController
  include CardScoped

  def create
    @card.watch_by Current.user
    redirect_back_or_to @card
  end

  def destroy
    @card.unwatch_by Current.user
    redirect_back_or_to @card
  end
end
