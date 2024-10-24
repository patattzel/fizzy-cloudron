module Bubble::Eventable
  extend ActiveSupport::Concern

  included do
    after_create -> { track_event :created }
  end

  private
    def track_event(action, creator: Current.user, **particulars)
      Event.create! action: action, creator: creator, rollup: latest_rollup, particulars: { creator_name: creator.name }.merge(particulars)
    end
end
