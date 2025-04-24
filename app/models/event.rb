class Event < ApplicationRecord
  include Notifiable, Particulars

  belongs_to :collection
  belongs_to :creator, class_name: "User"
  belongs_to :eventable, polymorphic: true
  belongs_to :summary, touch: true, class_name: "EventSummary"

  scope :chronologically, -> { order created_at: :asc, id: :desc }

  # TODO: Remove dependency with last_active_at via hook
  after_create -> { eventable.touch(:last_active_at) }

  def action
    super.inquiry
  end

  def notifiable_target
    if action.commented?
      comment
    else
      eventable
    end
  end

  # TODO: This doesn't belong here anymore
  def initial_assignment?
    action == "published" && eventable.assigned_to?(creator)
  end
end
