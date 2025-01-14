class Notifier::Commented < Notifier
  private
    def title
      "RE: " + super
    end

    def body
      "#{event.creator.name}"
    end

    def resource
      event.comment
    end
end
