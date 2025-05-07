class CommandsController < ApplicationController
  def index
    @commands = Current.user.commands.order(created_at: :desc).limit(20)
  end

  def create
    command = parse_command(params[:command])

    if command&.valid?
      result = command.execute

      case result
      when Command::Result::Redirection
        redirect_to result.url
      else
        redirect_back_or_to root_path
      end
    else
      head :unprocessable_entity
    end
  end

  private
    def parse_command(string)
      Command::Parser.new(parsing_context).parse(string).tap do |command|
        Current.user.commands << command
      end
    end

    def parsing_context
      Command::Parser::Context.new(Current.user, url: request.referrer)
    end
end
