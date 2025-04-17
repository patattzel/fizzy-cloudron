class Cards::EngagementsController < ApplicationController
  include CardScoped

  def create
    @card.engage
    rerender_card_container
  end

  def destroy
    @card.reconsider
    rerender_card_container
  end
end
