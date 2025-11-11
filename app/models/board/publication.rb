class Board::Publication < AccountScopedRecord
  belongs_to :board

  has_secure_token :key
end
