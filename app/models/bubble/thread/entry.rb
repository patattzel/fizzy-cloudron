class Bubble::Thread::Entry < ApplicationRecord
  belongs_to :thread, touch: true

  delegated_type :threadable, types: Threadable::TYPES, inverse_of: :thread_entry, dependent: :destroy

  after_touch -> { thread.touch }

  scope :chronologically, -> { order created_at: :asc, id: :desc }

  def to_partial_path
    "bubbles/threads/entries/entry"
  end
end
