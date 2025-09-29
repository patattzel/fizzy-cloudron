class Card::NotNow < ApplicationRecord
  belongs_to :card, class_name: "::Card", touch: true
end
