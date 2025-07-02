class Step < ApplicationRecord
  belongs_to :card, touch: true

  scope :completed, -> { where(completed: true) }

  def completed?
    completed
  end
end
