class Command
  include Rails.application.routes.url_helpers

  def execute
    raise NotImplementedError
  end

  private
    def redirect_to(...)
      Command::Result::Redirection.new(...)
    end
end
