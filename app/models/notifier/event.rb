class Notifier::Event < Notifier
  delegate :card, :creator, to: :source

  private
    def resource
      if source.action.commented?
        source.comment
      else
        card
      end
    end

    def recipients
      case source.action
        when "assigned"
          source.assignees.excluding(card.collection.access_only_users)
        when "published"
          card.watchers_and_subscribers(include_only_watching: true).without(creator)
        else
          card.watchers_and_subscribers.without(creator)
      end
    end
end
