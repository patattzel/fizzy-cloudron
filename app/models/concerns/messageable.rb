module Messageable
  extend ActiveSupport::Concern

  TYPES = %w[ Comment EventSummary ]

  included do
    has_one :message, as: :messageable

    after_create -> { create_message! bubble: bubble }
    after_update -> { message.touch }
    after_touch -> { message.touch }
  end
end
