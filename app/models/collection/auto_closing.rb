module Collection::AutoClosing
  extend ActiveSupport::Concern

  included do
    before_create :set_default_auto_close_period
  end

  private
    DEFAULT_AUTO_CLOSE_PERIOD = 30.days

    def set_default_auto_close_period
      self.auto_close_period ||= DEFAULT_AUTO_CLOSE_PERIOD unless attribute_present?(:auto_close_period)
    end
end
