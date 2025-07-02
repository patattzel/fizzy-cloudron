module Card::Multistep
  extend ActiveSupport::Concern

  included do
    has_many :steps, dependent: :destroy
  end

  def completed_steps_count
    steps.where(completed: true).count
  end
end
