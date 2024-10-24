module Bubble::Eventable
  extend ActiveSupport::Concern

  included do
    has_many :events, dependent: :destroy

    after_create -> { track_event :created }
  end

  private
    def track_event(action, creator: Current.user, **particulars)
      events.create! action: action, creator: creator, rollup: thread.latest_rollup, particulars: particulars
    end
end
