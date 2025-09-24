module Card::Triageable
  extend ActiveSupport::Concern

  included do
    belongs_to :column, optional: true

    scope :untriaged, -> { where.missing(:column) }
    scope :triaged, -> { joins(:column) }
  end
end
