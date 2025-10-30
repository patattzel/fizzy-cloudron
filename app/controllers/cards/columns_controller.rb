class Cards::ColumnsController < ApplicationController
  def edit
    @card = Current.user.accessible_cards.find(params[:card_id])
  end
end
