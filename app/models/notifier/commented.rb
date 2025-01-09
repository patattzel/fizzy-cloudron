class Notifier::Commented < Notifier
  private
    def body
      "#{creator.name} commented on: #{bubble.title}"
    end

    def recipients
      bubble.bucket.users.without(creator)
    end
end
