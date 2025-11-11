class AccountScopedRecord < ApplicationRecord
  self.abstract_class = true

  include UuidPrimaryKey
end
