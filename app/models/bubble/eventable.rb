module Bubble::Eventable
  extend ActiveSupport::Concern

  included do
    has_many :events, dependent: :delete_all

    after_create -> { track_event :created }
  end

  private
    def track_event(action, creator: Current.user, **particulars)
      events.create! action: action, creator: creator, summary: latest_event_summary, particulars: particulars
    end
end
