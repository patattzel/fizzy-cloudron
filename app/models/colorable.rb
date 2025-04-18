module Colorable
  extend ActiveSupport::Concern

  # COLORS = %w[ #3b3633 #67695e #eb7a32 #bf7c2b #c09c6f #746b1e #2c6da8 #5d618f #663251 #ff63a8 ]
  # DEFAULT_COLOR = "#2c6da8"

  COLORS = [
    "var(--color-card-1)",
    "var(--color-card-2)",
    "var(--color-card-3)",
    "var(--color-card-4)",
    "var(--color-card-5)",
    "var(--color-card-6)",
    "var(--color-card-7)",
    "var(--color-card-8)",
    "var(--color-card-9)",
  ]
  DEFAULT_COLOR = "var(--color-card-6)"

  included do
    attribute :color, default: DEFAULT_COLOR
  end
end
