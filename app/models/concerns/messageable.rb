module Messageable
  extend ActiveSupport::Concern

  TYPES = %w[ Comment EventSummary ]

  included do
    has_one :message, as: :messageable, touch: true
    has_one :bubble, through: :message
  end

  def captured_as(...)
  end

  def uncaptured_as(...)
  end
end
