class Collections::PublicationsController < ApplicationController
  include CollectionScoped

  def create
    @collection.publish
    redirect_to edit_collection_path(@collection)
  end

  def destroy
    @collection.unpublish
    redirect_to edit_collection_path(@collection)
  end
end
