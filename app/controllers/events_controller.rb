class EventsController < ApplicationController
  before_action :set_activity_day

  def index
    @events = Event.
      where(bubble: user_bubbles).
      where(created_at: @activity_day.yesterday.beginning_of_day..@activity_day.tomorrow.end_of_day)

    @next_day = @activity_day.yesterday.strftime("%Y-%m-%d")
  end

  private
    def user_bubbles
      Current.user.accessible_bubbles.published_or_drafted_by(Current.user)
    end

    def set_activity_day
      @activity_day = if params[:day].present?
        Time.zone.parse(params[:day])
      else
        Time.zone.now
      end
    rescue ArgumentError
      raise ActionController::RoutingError
    end
end
