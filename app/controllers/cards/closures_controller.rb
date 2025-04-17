class Cards::ClosuresController < ApplicationController
  include CardScoped

  def create
    @card.close(user: Current.user, reason: params[:reason])
    rerender_card
  end

  def destroy
    @card.reopen
    rerender_card
  end
end
