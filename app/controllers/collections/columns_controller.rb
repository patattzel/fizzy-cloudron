class Collections::ColumnsController < ApplicationController
  include CollectionScoped

  before_action :set_column, only: :show

  def create
    @column = @collection.columns.create!(column_params)
    render turbo_stream: turbo_stream.before("closed-cards", partial: "collections/show/column", locals: { column: @column })
  end

  def show
    set_page_and_extract_portion_from @column.cards.active.reverse_chronologically
  end

  private
    def set_column
      @column = @collection.columns.find(params[:id])
    end

    def column_params
      params.require(:column).permit(:name)
    end
end
