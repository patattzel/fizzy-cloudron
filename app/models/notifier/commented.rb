class Notifier::Commented < Notifier
  private
    def resource
      event.comment
    end
end
