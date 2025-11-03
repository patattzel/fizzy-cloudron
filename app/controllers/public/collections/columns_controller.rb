class Public::Collections::ColumnsController < Public::BaseController
  before_action :set_column, only: :show

  def show
    set_page_and_extract_portion_from @column.cards.active.latest.with_golden_first
  end

  private
    # Unlike the other public controllers, this is using params[:id] to fetch the column
    def set_collection_and_card
      @collection = Collection.find_by_published_key(params[:collection_id])
    end

    def set_column
      @column = @collection.columns.find(params[:id])
    end
end
