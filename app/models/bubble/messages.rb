module Bubble::Messages
  extend ActiveSupport::Concern

  included do
    has_many :messages, -> { chronologically }, dependent: :destroy
  end

  def latest_event_summary
    messages.last&.event_summary || EventSummary.new(bubble: self)
  end
end
