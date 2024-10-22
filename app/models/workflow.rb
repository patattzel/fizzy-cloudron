class Workflow < ApplicationRecord
  belongs_to :account
  has_many :stages, dependent: :delete_all
end
