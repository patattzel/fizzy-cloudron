module Bubble::Eventable
  extend ActiveSupport::Concern

  included do
    has_many :events # destroyed via thread_entry
    after_create -> { track_event :created }
  end

  private
    def track_event(action, creator: Current.user, **particulars)
      events.create! action: action, creator: creator, rollup: latest_rollup, particulars: { creator_name: creator.name }.merge(particulars)
    end
end
