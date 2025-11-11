class Card::Engagement < AccountScopedRecord
  belongs_to :card, class_name: "::Card", touch: true

  validates :status, presence: true, inclusion: { in: %w[doing on_deck] }
end
