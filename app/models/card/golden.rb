module Card::Golden
  extend ActiveSupport::Concern

  included do
    scope :golden, -> { joins(:goldness) }

    has_one :goldness, dependent: :destroy, class_name: "Card::Goldness"

    scope :with_golden_first, -> do
      left_outer_joins(:goldness).tap do |relation|
        # Make sure it can be layered in with other orderings taking precedence.
        relation.order_values.unshift("card_goldnesses.id IS NULL")
      end
    end
  end

  def golden?
    goldness.present?
  end

  def gild
    create_goldness! unless golden?
  end

  def ungild
    goldness&.destroy
  end
end
