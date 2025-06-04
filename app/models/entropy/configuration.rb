class Entropy::Configuration < ApplicationRecord
  belongs_to :container, polymorphic: true
end
