class Cards::CollectionsController < ApplicationController
  before_action :set_collection, only: %i[ update ]

  def edit
    @card = Current.user.accessible_cards.find(params[:card_id])
    @collections = Current.user.collections.ordered_by_recently_accessed
  end

  def update
    @card = Current.user.accessible_cards.find(params[:card_id])
    @card.move_to(@collection)
    redirect_to @card
  end

  private
    def set_collection
      @collection = Current.user.collections.find(params[:collection_id])
    end
end
