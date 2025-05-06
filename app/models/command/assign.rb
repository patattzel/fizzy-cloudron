class Command::Assign < Command
  store_accessor :data, :card_ids, :assignee_ids

  def execute
    Rails.logger.info "*** #{assignees.collect(&:name)}"

    transaction do
      cards.each do |card|
        assignees.each do |assignee|
          card.toggle_assignment(assignee) unless card.assigned_to?(assignee)
        end
      end
    end
  end

  def undo
    raise "pending"
  end

  def description
    raise "pending"
  end

  def to_command
    raise "pending"
  end

  private
    def assignees
      User.where(id: assignee_ids)
    end

    def cards
      user.accessible_cards.where(id: card_ids)
    end
end
