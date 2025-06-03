module Cards
  class CollectionsController < ApplicationController
    def update
      @card = Card.find(params[:card_id])
      @card.update!(collection_id: params[:collection_id])
      redirect_to @card
    end
  end
end
