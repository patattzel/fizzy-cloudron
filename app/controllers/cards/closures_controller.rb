class Cards::ClosuresController < ApplicationController
  include CardScoped

  def create
    @card.close(user: Current.user, reason: params[:reason])
    rerender_card_container
  end

  def destroy
    @card.reopen
    rerender_card_container
  end
end
