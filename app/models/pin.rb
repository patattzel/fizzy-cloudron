class Pin < AccountScopedRecord
  belongs_to :card
  belongs_to :user

  scope :ordered, -> { order(created_at: :desc) }
end
