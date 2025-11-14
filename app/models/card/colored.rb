module Card::Colored
  extend ActiveSupport::Concern

  DEFAULT_COLOR = Color::COLORS.first

  def color
    column&.color || DEFAULT_COLOR
  end
end
