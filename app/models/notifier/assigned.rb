class Notifier::Assigned < Notifier
  private
    def body
      "#{creator.name} assigned you: #{bubble.title}"
    end

    def recipients
      event.assignees.without(creator)
    end
end
