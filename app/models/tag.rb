class Tag < ApplicationRecord
  include Filterable

  belongs_to :account, default: -> { Current.account }

  has_many :taggings, dependent: :destroy
  has_many :bubbles, through: :taggings

  scope :search, ->(query) { where "title LIKE ?", "%#{query}%" }

  def hashtag
    "#" + title
  end

  def to_combobox_display
    title
  end
end
