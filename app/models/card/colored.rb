module Card::Colored
  extend ActiveSupport::Concern

  def color
    color_from_stage || Colorable::DEFAULT_COLOR
  end

  private
    def color_from_stage
      stage&.color&.presence if doing?
    end
end
