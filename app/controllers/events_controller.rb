class EventsController < ApplicationController
  include DayTimelinesScoped

  enable_collection_filtering only: :index

  def index
  end
end
