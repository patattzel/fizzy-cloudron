module CurrentTimezone
  extend ActiveSupport::Concern

  included do
    around_action :set_current_timezone
  end

  private
    def set_current_timezone(&)
      Time.use_zone(timezone_from_cookie, &)
    end

    def timezone_from_cookie
      timezone = cookies[:timezone]
      timezone if timezone.present? && ActiveSupport::TimeZone[timezone]
    end
end
