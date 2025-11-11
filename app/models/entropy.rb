class Entropy < AccountScopedRecord
  belongs_to :container, polymorphic: true

  after_commit -> { container.cards.touch_all }
end
