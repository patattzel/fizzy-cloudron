module Card::Colored
  extend ActiveSupport::Concern

  COLORS = [
    { name: "Blue", value: "var(--color-card-default)" },
    { name: "Gray", value: "oklch(var(--lch-ink-dark))" },
    { name: "Tan", value: "oklch(var(--lch-uncolor-medium))" },
    { name: "Yellow", value: "oklch(var(--lch-yellow-medium))" },
    { name: "Lime", value: "oklch(var(--lch-lime-medium))" },
    { name: "Aqua", value: "oklch(var(--lch-aqua-medium))" },
    { name: "Violet", value: "oklch(var(--lch-violet-medium))" },
    { name: "Purple", value: "oklch(var(--lch-purple-medium))" },
    { name: "Pink", value: "oklch(var(--lch-pink-medium))" }
  ]
  DEFAULT_COLOR = COLORS.first

  def color
    if column&.color.present?
      found = COLORS.find { |c| c[:value] == column.color }
      found || { name: column.color, value: column.color }
    else
      DEFAULT_COLOR
    end
  end
end
