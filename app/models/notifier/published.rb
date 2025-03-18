class Notifier::Published < Notifier
  private
    def recipients
      bubble.watchers_and_subscribers.without(creator)
    end
end
