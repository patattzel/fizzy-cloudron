module Bubble::Eventable
  extend ActiveSupport::Concern

  included do
    after_create -> { track_event :created }
  end

  private
    def track_event(action, rollup: latest_rollup, creator: Current.user, **particulars)
      transaction do
        Event.create! action: action, creator: creator, rollup: rollup, particulars: { creator_name: creator.name }.merge(particulars)
        thread_entries.create! threadable: rollup
      end
    rescue ActiveRecord::RecordNotUnique
      # rollup has already been threaded
    end
end
