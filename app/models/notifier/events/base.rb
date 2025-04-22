class Notifier::Events::Base < Notifier
  delegate :card, to: :source

  private
    def resource
      card
    end

    def recipients
      card.watchers_and_subscribers.without(creator)
    end
end
