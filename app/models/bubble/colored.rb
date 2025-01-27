module Bubble::Colored
  extend ActiveSupport::Concern

  COLORS = %w[ #BF1B1B #ED3F1C #ED8008 #7C956B #698F9C #266ec3 #3B4B59 #5D618F #3B3633 #67695E ]

  included do
    attribute :color, default: "#266ec3"
  end
end
