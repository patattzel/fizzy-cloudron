class Card::ActivitySpike < AccountScopedRecord
  belongs_to :card, touch: true
end
