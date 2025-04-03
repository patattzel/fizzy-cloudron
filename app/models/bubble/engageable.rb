module Bubble::Engageable
  extend ActiveSupport::Concern

  included do
    has_one :engagement, dependent: :destroy, class_name: "Bubble::Engagement"

    scope :doing, -> { joins(:engagement) }
    scope :considering, -> { where.missing(:engagement) }
  end

  def doing?
    engagement.present?
  end

  def considering?
    !doing?
  end

  def engage
    unless doing?
      create_engagement!
    end
  end

  def reconsider
    engagement&.destroy
  end
end
