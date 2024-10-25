class EventSummary < ApplicationRecord
  include Messageable

  attr_accessor :bubble

  has_many :events, -> { chronologically }, dependent: :delete_all, inverse_of: :summary
end
