class Rollup < ApplicationRecord
  include Threadable

  belongs_to :bubble

  has_many :events, -> { chronologically }, dependent: :delete_all
end
