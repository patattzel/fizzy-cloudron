class ThreadEntry < ApplicationRecord
  belongs_to :bubble, touch: true

  delegated_type :threadable, types: %w[ Comment Rollup ], inverse_of: :thread_entry, dependent: :destroy

  scope :chronologically, -> { order created_at: :asc, id: :desc }
end
