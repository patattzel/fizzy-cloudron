class Step < ApplicationRecord
  belongs_to :card, touch: true

  def completed?
    completed
  end
end
