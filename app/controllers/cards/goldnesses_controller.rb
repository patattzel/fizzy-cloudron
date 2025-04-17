class Cards::GoldnessesController < ApplicationController
  include CardScoped

  def create
    @card.gild
    rerender_card
  end

  def destroy
    @card.ungild
    rerender_card
  end
end
