module Account::Entropic
  extend ActiveSupport::Concern

  included do
    has_one :default_entropy_configuration, class_name: "Entropy::Configuration", as: :container, dependent: :destroy

    before_save :set_default_entropy_configuration
  end

  private
    DEFAULT_ENTROPY_PERIOD = 30.days

    def set_default_entropy_configuration
      self.default_entropy_configuration ||= build_default_entropy_configuration \
        auto_postpone_period: DEFAULT_ENTROPY_PERIOD
    end
end
