module PublicCollectionScoped
  extend ActiveSupport::Concern

  included do
    before_action :set_collection
  end

  private
    def set_collection
      @collection = Collection.find_by_published_key(params[:collection_id] || params[:id])
    end
end
