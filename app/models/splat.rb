class Splat < ApplicationRecord
  has_many :categorizations
  has_many :categories, through: :categorizations, dependent: :destroy

  enum :color, %w[ dodgerblue teal tomato slateblue ].index_by(&:itself), suffix: true, default: :dodgerblue
end
