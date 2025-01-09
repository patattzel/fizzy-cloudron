class Notifier::Created < Notifier
  private
    def body
      "#{creator.name} created a new item: #{bubble.title}"
    end

    def recipients
      bubble.bucket.users.without(creator)
    end
end
