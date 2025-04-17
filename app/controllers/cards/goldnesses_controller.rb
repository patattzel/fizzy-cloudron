class Cards::GoldnessesController < ApplicationController
  include CardScoped

  def create
    @card.gild
    rerender_card_container
  end

  def destroy
    @card.ungild
    rerender_card_container
  end
end
