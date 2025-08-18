class CommandsController < ApplicationController
  def create
    command = parse_command(params[:command])
    result = command.execute
    respond_with_execution_result(result)
  end

  private
    def parse_command(string)
      command_parser.parse(string)
    end

    def command_parser
      @command_parser ||= Command::Parser.new(user: Current.user, script_name: request.script_name)
    end

    def respond_with_execution_result(result)
      # This saves unnecessary back and forth between server and client (e.g: to redirect)-
      result = result.is_a?(Array) && result.one? ? result.first : result

      case result
      when Command::Result::Redirection
        redirect_to result.url
      when Command::Result::ShowModal
        respond_with_turbo_frame_modal(result.turbo_frame, result.url)
      else
        redirect_back_or_to root_path
      end
    end

    def respond_with_turbo_frame_modal(turbo_frame, url)
      render json: { turbo_frame: turbo_frame, url: url }, status: :accepted
    end
end
