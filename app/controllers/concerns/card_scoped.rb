module CardScoped
  extend ActiveSupport::Concern

  included do
    before_action :set_card, :set_collection
  end

  private
    def set_card
      @card = Current.user.accessible_cards.find(params[:card_id])
    end

    def set_collection
      @collection = @card.collection
    end

    def rerender_card
      render turbo_stream: turbo_stream.replace([ @card, :card_container ], partial: "cards/container", locals: { card: @card.reload })
    end
end
