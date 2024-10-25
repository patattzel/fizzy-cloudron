class EventSummary < ApplicationRecord
  include Messageable

  attr_accessor :bubble

  has_many :events, -> { chronologically }, dependent: :delete_all, inverse_of: :summary do
    def grouped_boosts
      boosts.group_by(&:creator)
    end
  end
end
