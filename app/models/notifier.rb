class Notifier
  attr_reader :event

  class << self
    def for(event)
      "Notifier::#{event.action.classify}".safe_constantize&.new(event)
    end
  end

  def generate
    recipients.map do |recipient|
      Notification.create! user: recipient, creator: event.creator, resource: bubble, body: body
    end
  end

  private
    def initialize(event)
      @event = event
    end

    def body
      raise NotImplementedError
    end

    def recipients
      raise NotImplementedError
    end

    def bubble
      @event.summary.message.bubble
    end

    def creator
      @event.creator
    end
end
