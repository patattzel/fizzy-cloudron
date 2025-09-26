module Card::Triageable
  extend ActiveSupport::Concern

  included do
    belongs_to :column, optional: true

    scope :awaiting_triage, -> { active.where.missing(:column) }
    scope :triaged, -> { active.joins(:column) }
  end

  def triaged?
    active? && column.present?
  end

  def awaiting_triage?
    active? && !triaged?
  end

  def triage_to(column)
    raise "The column must belong to the card collection" unless collection == column.collection
    update! column: column
  end

  def send_back_to_triage
    update!(column: nil)
  end
end
