class Command::Assign < Command
  store_accessor :data, :card_ids, :assignee_ids

  validates_presence_of :card_ids, :assignee_ids

  def execute
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

  def title
    card_description = if cards.one?
      "card '#{cards.first.title}'"
    else
      "#{cards.count} cards"
    end

    assignee_description = assignees.collect(&:first_name).join(", ")

    "Assign #{assignee_description} to #{card_description}"
  end

  private
    def assignees
      User.where(id: assignee_ids)
    end

    def cards
      user.accessible_cards.where(id: card_ids)
    end
end
