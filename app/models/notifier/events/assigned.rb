class Notifier::Events::Assigned < Notifier::Events::Base
  private
    def recipients
      source.assignees.excluding(card.collection.access_only_users)
    end
end
