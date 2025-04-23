class CollectionFilterPresenter
  def initialize(collections, params, cookies)
    @collections = collections
    @params = params
    @cookies = cookies
  end

  def filter_text
    if selected_collection_ids.present?
      "Activity in #{selected_collection_names_bold}".html_safe
    else
      "Activity in all collections"
    end
  end

  private
    def selected_collection_ids
      @params[:collection_ids].presence || @cookies[:collection_filter]&.split(",")
    end

    def selected_collection_names
      @collections.where(id: selected_collection_ids).pluck(:name).to_sentence
    end

    def selected_collection_names_bold
      names = @collections.where(id: selected_collection_ids).pluck(:name)
      names.map { |name| "<strong>#{name}</strong>" }.to_sentence
    end
end
