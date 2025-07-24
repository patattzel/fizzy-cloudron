class Card::Eventable::SystemCommenter
  attr_reader :card, :event

  def initialize(card, event)
    @card, @event = card, event
  end

  def comment
    return unless comment_body.present?

    card.comments.create! creator: User.system, body: comment_body, created_at: event.created_at
  end

  private
    def comment_body
      case event.action
      when "card_assigned"
        "<strong>Assigned</strong> to #{event.assignees.pluck(:name).to_sentence} by #{event.creator.name}."
      when "card_unassigned"
        "<strong>Unassigned</strong> from #{event.assignees.pluck(:name).to_sentence} by #{event.creator.name}."
      when "card_staged"
        "<strong>Moved to ‘#{event.stage_name}’</strong> by #{event.creator.name}."
      when "card_closed"
        "<strong>Closed as ‘#{ card.closure.reason }’</strong> by #{ event.creator.name }"
      when "card_reopened"
        "<strong>Reopened</strong> by #{ event.creator.name }"
      when "card_title_changed"
        "<strong>Title changed</strong> from ‘#{event.particulars.dig('particulars', 'old_title')}’ to ‘#{event.particulars.dig('particulars', 'new_title')}’ by #{event.creator.name}."
      when "card_collection_changed"
      "<strong>Moved</strong> from ‘#{event.particulars.dig('particulars', 'old_collection')}’ to ‘#{event.particulars.dig('particulars', 'new_collection')}’ by #{event.creator.name}."
      end
    end
end
