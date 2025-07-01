class Tag < ApplicationRecord
  include ActionText::Attachable, Filterable

  has_many :taggings, dependent: :destroy
  has_many :cards, through: :taggings

  validates :title, format: { without: /\A#/ }
  normalizes :title, with: -> { it.downcase }

  scope :alphabetically, -> { order("lower(title)") }
  scope :unused, -> { left_outer_joins(:taggings).where(taggings: { id: nil }) }

  def hashtag
    "#" + title
  end

  # TODO: Move to attachable along with the concern
  def attachable_plain_text_representation(...)
    "##{title}"
  end
end
