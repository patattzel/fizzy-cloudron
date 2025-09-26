class Collections::ColumnsController < ApplicationController
  include CollectionScoped

  before_action :set_column

  def show
    set_page_and_extract_portion_from @column.cards.active.reverse_chronologically
  end

  private
    def set_column
      @column = @collection.columns.find(params[:id])
    end
end
