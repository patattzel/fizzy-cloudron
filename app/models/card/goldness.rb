class Card::Goldness < AccountScopedRecord
  belongs_to :card, touch: true
end
