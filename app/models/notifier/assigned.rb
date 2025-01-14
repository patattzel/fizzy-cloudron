class Notifier::Assigned < Notifier
  private
    def recipients
      event.assignees.without(creator)
    end
end
