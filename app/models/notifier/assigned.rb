class Notifier::Assigned < Notifier
  private
    def recipients
      event.assignees
    end
end
