class EventsController < ApplicationController
  include DayTimelinesScoped

  enable_collection_filtering only: :index

  def index
    Rails.logger.info "***** #{@day_timeline.cache_key}"
    fresh_when @day_timeline
  end
end
