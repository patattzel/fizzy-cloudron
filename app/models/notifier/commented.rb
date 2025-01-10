class Notifier::Commented < Notifier
  private
    def body
      "commented on: #{bubble.title}"
    end

    def resource
      event.comment
    end
end
