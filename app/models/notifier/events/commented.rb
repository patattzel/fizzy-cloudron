class Notifier::Events::Commented < Notifier::Events::Base
  private
    def resource
      source.comment
    end
end
