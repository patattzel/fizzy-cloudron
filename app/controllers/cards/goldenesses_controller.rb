class Cards::GoldenessesController < ApplicationController
  include CardScoped

  def create
    @card.gild
    redirect_to @card
  end

  def destroy
    @card.ungild
    redirect_to @card
  end
end
