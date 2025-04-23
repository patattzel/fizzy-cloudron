class Notifier::Event < Notifier
  delegate :card, :creator, to: :source
  delegate :watchers_and_subscribers, to: :card

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
          watchers_and_subscribers(include_only_watching: true).without(creator, *mentionees)
        when "commented"
          watchers_and_subscribers.without(creator, *mentionees)
        else
          watchers_and_subscribers.without(creator)
      end
    end

    def mentionees
      case source.action
        when "published"
          source.card.mentionees
        when "commented"
          source.comment.mentionees
        else
          []
      end
    end
end
