class Card::NotNow < AccountScopedRecord
  belongs_to :card, class_name: "::Card", touch: true
  belongs_to :user, optional: true
end
