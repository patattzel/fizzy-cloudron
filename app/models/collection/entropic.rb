module Collection::Entropic
  extend ActiveSupport::Concern

  included do
    delegate :auto_postpone_period, to: :entropy_configuration
  end

  def entropy_configuration
    super || Entropy::Configuration.default
  end

  def auto_postpone_period=(new_value)
    entropy_configuration ||= association(:entropy_configuration).reader || self.build_entropy_configuration
    entropy_configuration.update auto_postpone_period: new_value
  end
end
