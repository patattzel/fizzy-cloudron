class Message < ApplicationRecord
  belongs_to :bubble, touch: true

  delegated_type :messageable, types: Messageable::TYPES, inverse_of: :message, dependent: :destroy

  scope :chronologically, -> { order created_at: :asc, id: :desc }

  after_create :captured
  after_destroy :uncaptured

  private
    def captured
      messageable.captured_as(self)
    end

    def uncaptured
      messageable.uncaptured_as(self)
    end
end
