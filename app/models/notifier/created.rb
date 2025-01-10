class Notifier::Created < Notifier
  private
    def body
      "created: #{bubble.title}"
    end

    def recipients
      bubble.bucket.users.without(creator)
    end
end
