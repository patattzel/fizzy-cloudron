module Bubble::Eventable
  extend ActiveSupport::Concern

  included do
    has_many :event_summary_messages, -> { event_summaries }, class_name: "Message"
    has_many :event_summaries, through: :event_summary_messages, source: :messageable, source_type: "EventSummary"

    after_create -> { track_event :created }
  end

  private
    def track_event(action, creator: Current.user, **particulars)
      transaction do
        find_or_create_next_summary.events << Event.new(action: action, creator: creator, particulars: particulars)
      end
    end

    def find_or_create_next_summary
      messages.last&.event_summary || capture(event_summaries.build).messageable
    end
end
