class Account < ApplicationRecord
  include Entropic, Joinable

  has_many_attached :uploads
end
