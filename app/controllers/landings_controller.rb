class LandingsController < ApplicationController
  def show
    if Current.user.boards.one?
      redirect_to board_path(Current.user.boards.first)
    else
      redirect_to events_path
    end
  end
end
