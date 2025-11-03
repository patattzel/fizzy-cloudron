class Public::BaseController < ApplicationController
  allow_unauthenticated_access
  allow_unauthorized_access

  before_action :set_collection_and_card
  before_action :set_public_cache_expiration

  layout "public"

  private
    def set_collection_and_card
      @collection = Collection.find_by_published_key(params[:collection_id] || params[:id])
      @card = @collection.cards.find(params[:id]) if params[:collection_id] && params[:id]
    end

    def set_public_cache_expiration
      expires_in 30.seconds, public: true
    end
end
