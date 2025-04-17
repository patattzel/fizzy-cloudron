class Cards::EngagementsController < ApplicationController
  include CardScoped

  def create
    @card.engage
    rerender_card
  end

  def destroy
    @card.reconsider
    rerender_card
  end
end
