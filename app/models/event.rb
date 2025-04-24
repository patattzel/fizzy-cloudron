class Event < ApplicationRecord
  include Notifiable, Particulars

  belongs_to :creator, class_name: "User"
  belongs_to :card

  scope :chronologically, -> { order created_at: :asc, id: :desc }

  after_create -> { card.touch(:last_active_at) }

  def action
    super.inquiry
  end

  def notifiable_target
    if action.commented?
      comment
    else
      card
    end
  end

  def initial_assignment?
    action == "published" && card.assigned_to?(creator)
  end
end
