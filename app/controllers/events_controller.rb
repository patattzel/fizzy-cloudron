class EventsController < ApplicationController
  before_action :set_activity_day

  def index
    @events = unique_events_by_hour_and_column
    @next_day = @activity_day.yesterday.strftime("%Y-%m-%d")
  end

  private
    def unique_events_by_hour_and_column
      events_by_hour_and_column.map { |hour_col, events| [ hour_col, events.uniq(&:bubble_id) ] }
    end

    def events_by_hour_and_column
      user_events.group_by { |event| [ event.created_at.hour, helpers.event_column(event) ] }
    end

    def user_events
      Event.where(bubble: user_bubbles).where(created_at: @activity_day.all_day)
    end

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
