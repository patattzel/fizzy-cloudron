module Card::Triageable
  extend ActiveSupport::Concern

  included do
    belongs_to :column, optional: true

    scope :untriaged, -> { active.where.missing(:column) }
    scope :triaged, -> { active.joins(:column) }
  end

  def triaged?
    active? && column.present?
  end

  def untriaged?
    !triaged?
  end
end
