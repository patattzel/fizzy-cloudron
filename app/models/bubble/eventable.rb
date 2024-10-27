module Bubble::Eventable
  extend ActiveSupport::Concern

  included do
    after_create -> { track_event :created }
  end

  private
    def track_event(action, creator: Current.user, **particulars)
      transaction do
        find_or_capture_event_summary.events << Event.new(action: action, creator: creator, particulars: particulars)
      end
    end

    def find_or_capture_event_summary
      messages.last&.event_summary || capture(EventSummary.new).event_summary
    end
end
