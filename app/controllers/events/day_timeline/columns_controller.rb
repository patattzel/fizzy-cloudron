class Events::DayTimeline::ColumnsController < ApplicationController
  include DayTimelinesScoped

  def show
    @column = column_for_id(params[:id])
    fresh_when @day_timeline
  end

  private
    def column_for_id(id)
      @day_timeline.try("#{id}_column") or head :not_found
    end
end
