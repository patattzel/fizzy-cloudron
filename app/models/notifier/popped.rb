class Notifier::Popped < Notifier
  private
    def body
      "popped: #{bubble.title}"
    end
end
