class Bubble::Thread < ApplicationRecord
  belongs_to :bubble, touch: true

  has_many :entries, -> { chronologically }, dependent: :destroy

  def latest_rollup
    entries.last&.event_rollup || Event::Rollup.new(thread: self)
  end

  def to_partial_path
    "bubbles/threads/thread"
  end
end
