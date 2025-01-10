class Notifier::Commented < Notifier
  private
    def body
      "commented on: #{bubble.title}"
    end

    def recipients
      bubble.bucket.users.without(creator)
    end

    def resource
      event.comment
    end
end
