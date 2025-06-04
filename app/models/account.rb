class Account < ApplicationRecord
  include Entropy, Joinable

  has_many_attached :uploads
end
