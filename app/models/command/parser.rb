class Command::Parser
  attr_reader :user, :script_name

  def initialize(user: user, script_name:)
    @user = user
    @script_name = script_name
  end

  def parse(string)
    parse_command(string).tap do |command|
      command.default_url_options[:script_name] = script_name
    end
  end

  private
    def parse_command(string)
      parse_rich_text_command as_plain_text_with_attachable_references(string)
    end

    def as_plain_text_with_attachable_references(string)
      ActionText::Content.new(string).render_attachments(&:to_gid).fragment.to_plain_text
    end

    def parse_rich_text_command(string)
      command_name, *command_arguments = string.strip.split(" ")
      combined_arguments = command_arguments.join(" ")

      case command_name
      when "/ask"
        Command::Ask.new(combined_arguments)
      else
        parse_free_string(string)
      end
    end

    def parse_free_string(string)
      if card = single_card_from(string)
        Command::GoToCard.new(card)
      else
        parse_with_fallback(string)
      end
    end

    def single_card_from(string)
      user.accessible_cards.find_by_id(string)
    end

    def parse_with_fallback(string)
      Command::Search.new(string)
    end
end
