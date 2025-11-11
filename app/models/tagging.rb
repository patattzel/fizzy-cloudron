class Tagging < AccountScopedRecord
  belongs_to :tag
  belongs_to :card, touch: true
end
