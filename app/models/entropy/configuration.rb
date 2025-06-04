class Entropy::Configuration < ApplicationRecord
  belongs_to :container, polymorphic: true

  scope :default, -> { where(container_type: "Account").limit(1) }
end
