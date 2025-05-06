class CommandsController < ApplicationController
  def create
    command = parse_command(params[:command])

    if command
      result = command.execute

      case result
        when Command::Result::Redirection
          redirect_to url_for(result.url)
        else
          redirect_back_or_to root_path
      end
    else
      raise "Pending to handle invalid commands"
    end
  end

  private
    def parse_command(string)
      Command::Parser.new(parsing_context).parse(string).tap do |command|
        Current.user.commands << command if command
      end
    end

    def parsing_context
      Command::Parser::Context.new(Current.user, url: request.referrer)
    end

    def card_ids_from_header
      request.headers["X-Cards"].to_s.split(",").map(&:to_i) if request.headers["X-Card-Ids"]
    end
end
