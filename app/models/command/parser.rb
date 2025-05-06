class Command::Parser
  attr_reader :context

  delegate :user, :cards, to: :context

  def initialize(context)
    @context = context
  end

  def parse(string)
    command_name, *command_arguments = string.split(" ")

    case command_name
      when "/assign", "/assign_to"
        Command::Assign.new(assignee_ids: assignees_from(command_arguments).collect(&:id), card_ids: cards.ids)
      else
        search(string)
    end
  end

  private
    def search(string)
      if card = user.accessible_cards.find_by_id(string)
        Command::GoToCard.new(card_id: card.id)
      else
        Command::Search.new(query: string)
      end
    end

    def assignees_from(strings)
      Array(strings).filter_map do |string|
        assignee_from(string)
      end
    end

    # TODO: This is temporary as it can be ambiguous. We should inject the user ID in the command
    #   instead, as determined by the user picker.
    def assignee_from(string)
      User.all.find { |user| user.mentionable_handles.include?(string) }
    end
end
