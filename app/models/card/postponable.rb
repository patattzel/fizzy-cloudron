module Card::Postponable
  extend ActiveSupport::Concern

  included do
    has_one :not_now, dependent: :destroy, class_name: "Card::NotNow"

    scope :not_now, -> { joins(:not_now) }
    scope :active, -> { where.missing(:not_now) }
  end

  def postponed?
    not_now.present?
  end

  def active?
    !postponed?
  end

  def postpone
    unless postponed?
      transaction do
        reopen
        activity_spike&.destroy
        create_not_now!
      end
    end
  end

  def resume
    if postponed?
      not_now.destroy
    end
  end
end
