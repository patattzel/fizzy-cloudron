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
      Command::Parser.new(Current.user).parse(string).tap do |command|
        Current.user.commands << command if command
      end
    end
end
