module Collection::AutoClosing
  extend ActiveSupport::Concern

  included do
    before_create :set_default_auto_postpone_period
  end

  private
    DEFAULT_auto_postpone_period = 30.days

    def set_default_auto_postpone_period
      self.auto_postpone_period ||= DEFAULT_auto_postpone_period unless attribute_present?(:auto_postpone_period)
    end
end
