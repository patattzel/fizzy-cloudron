module Collection::Entropy
  extend ActiveSupport::Concern

  included do
    delegate :auto_close_period, :auto_reconsider_period, to: :entropy_configuration
  end

  def entropy_configuration
    super || Entropy::Configuration.default
  end

  def auto_close_period=(new_value)
    entropy_configuration ||= association(:entropy_configuration).reader || self.build_entropy_configuration
    entropy_configuration.update auto_close_period: new_value
  end

  def auto_reconsider_period=(new_value)
    entropy_configuration ||= association(:entropy_configuration).reader || self.build_entropy_configuration
    entropy_configuration.update auto_reconsider_period: new_value
  end
end
