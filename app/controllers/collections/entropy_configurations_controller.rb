class Collections::EntropyConfigurationsController < ApplicationController
  include CollectionScoped

  def update
    @collection.entropy_configuration.update!(entropy_configuration_params)

    redirect_to edit_collection_path(@collection), notice: "Collection updated"
  end

  private
    def entropy_configuration_params
      params.expect(collection: [ :auto_close_period, :auto_reconsider_period ])
    end
end
