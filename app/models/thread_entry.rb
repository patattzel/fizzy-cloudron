class ThreadEntry < ApplicationRecord
  belongs_to :bubble

  delegated_type :threadable, types: %w[ Comment Rollup ], dependent: :destroy

  scope :chronologically, -> { order created_at: :asc, id: :desc }
end
