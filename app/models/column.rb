class Column < ApplicationRecord
  belongs_to :collection
  has_many :cards, dependent: :nullify

  validates :name, presence: true
  validates :color, presence: true

  before_validation :set_default_color

  private
    def set_default_color
      self.color ||= Card::DEFAULT_COLOR
    end
end
