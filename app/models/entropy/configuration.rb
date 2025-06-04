class Entropy::Configuration < ApplicationRecord
  belongs_to :container, polymorphic: true

  class << self
    def default
      Account.sole.default_entropy_configuration
    end
  end
end
