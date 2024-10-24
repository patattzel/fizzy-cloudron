class Rollup < ApplicationRecord
  include Threadable

  attr_accessor :bubble

  has_many :events, -> { chronologically }, dependent: :delete_all
end
