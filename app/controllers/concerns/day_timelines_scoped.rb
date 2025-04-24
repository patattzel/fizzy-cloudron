module DayTimelinesScoped
  extend ActiveSupport::Concern

  included do
    include FilterScoped

    before_action :restore_collections_filter, :set_day_timeline
  end

  private
    def restore_collections_filter
      cookies.delete(:collection_filter) if params[:clear_filter]
      set_collections_filter if cookies[:collection_filter].present?
    end

    def set_collections_filter
      @filter.collection_ids = cookies[:collection_filter].split(",")
      cookies[:collection_filter] = @filter.collection_ids.join(",")
    end

    def set_day_timeline
      @day_timeline = Current.user.timeline_for(day, filter: @filter)
    end

    def day
      if params[:day].present?
        Time.zone.parse(params[:day])
      else
        Time.current
      end
    rescue ArgumentError
      head :not_found
    end
end
