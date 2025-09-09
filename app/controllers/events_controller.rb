class EventsController < ApplicationController
  include DayTimelinesScoped

  enable_collection_filtering only: :index

  def index
    fresh_when @day_timeline
  end
end
