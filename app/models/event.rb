class Event < ApplicationRecord
  include Assignments, Stages

  belongs_to :creator, class_name: "User"
  belongs_to :bubble, touch: true
  belongs_to :summary, touch: true, class_name: "EventSummary"

  has_one :account, through: :creator

  scope :chronologically, -> { order created_at: :asc, id: :desc }
  scope :non_boosts, -> { where.not action: :boosted }
  scope :boosts, -> { where action: :boosted }
end
