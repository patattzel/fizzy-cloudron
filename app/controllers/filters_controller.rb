class FiltersController < ApplicationController
  def create
    filter = Current.user.filters.remember filter_params

    render turbo_stream: turbo_stream.replace("filter-toggle", partial: "filters/filter_toggle", locals: { filter: filter })
  end

  def destroy
    filter = Current.user.filters.find(params[:id])
    filter.destroy!

    render turbo_stream: turbo_stream.replace("filter-toggle", partial: "filters/filter_toggle", locals: { filter: filter })
  end

  private
    def filter_params
      params.permit(*Filter::PERMITTED_PARAMS).compact_blank
    end
end
