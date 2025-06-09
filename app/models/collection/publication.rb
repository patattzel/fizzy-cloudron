class Collection::Publication < ApplicationRecord
  belongs_to :collection

  has_secure_token :key
end
