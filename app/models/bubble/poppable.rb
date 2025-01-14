module Bubble::Poppable
  extend ActiveSupport::Concern

  included do
    has_one :pop, dependent: :destroy

    scope :popped, -> { joins(:pop) }
    scope :active, -> { where.missing(:pop) }
  end

  def popped?
    pop.present?
  end

  def pop!(user: Current.user)
    unless popped?
      create_pop!(user: user)
      track_event :popped
    end
  end

  def unpop
    pop&.destroy
  end
end
