class FiltersController < ApplicationController
  include FilterScoped

  def create
    @filter = Current.user.filters.remember filter_params

    render turbo_stream: turbo_stream.replace("filter-toggle", partial: "filters/filter_toggle", locals: { filter: @filter })
  end

  def destroy
    @filter.destroy!

    render turbo_stream: turbo_stream.replace("filter-toggle", partial: "filters/filter_toggle", locals: { filter: @filter })
  end
end
