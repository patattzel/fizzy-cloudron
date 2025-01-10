class Notifier::Commented < Notifier
  private
    def body
      "commented on: #{bubble.title}"
    end

    def recipients
      bubble.bucket.users.without(creator)
    end
end
