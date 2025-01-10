class Notifier::Created < Notifier
  private
    def body
      "created: #{bubble.title}"
    end
end
