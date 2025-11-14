module Column::Colored
  extend ActiveSupport::Concern

  included do
    before_validation -> { self[:color] ||= Card::Colored::DEFAULT_COLOR.value }
  end

  def color
    color_value = super
    Color.for_value(color_value) || Card::Colored::DEFAULT_COLOR
  end
end
