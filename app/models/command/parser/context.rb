class Command::Parser::Context
  attr_reader :user, :url

  def initialize(user, url:)
    @user = user
    @url = url
  end

  def cards
    route = Rails.application.routes.recognize_path(url)

    controller = route[:controller]
    action = route[:action]
    params = route.except(:controller, :action)

    cards_from(controller, action, params)
  end

  private
    def cards_from(controller, action, params)
      if controller == "cards" && action == "show"
        user.accessible_cards.where id: params[:id]
      elsif controller == "cards" && action == "index"
        filter = user.filters.from_params params.reverse_merge(**FilterScoped::DEFAULT_PARAMS)
        filter.cards
      end
    end
end
