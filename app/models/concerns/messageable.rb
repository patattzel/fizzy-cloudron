module Messageable
  extend ActiveSupport::Concern

  TYPES = %w[ Comment EventSummary ]

  included do
    has_one :message, as: :messageable, touch: true

    after_create -> { create_message! bubble: bubble }
  end
end
