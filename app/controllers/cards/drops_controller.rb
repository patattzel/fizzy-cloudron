class Cards::DropsController < ApplicationController
  include Collections::ColumnsScoped
  before_action :set_card, :set_drop_target

  def create
    perform_drop_action
    render_column_replacement
  end

  private
    VALID_DROP_TARGETS = %w[ considering on_deck doing closed ]

    def set_card
      @card = Current.user.accessible_cards.find(params[:dropped_item_id])
    end

    def set_drop_target
      if params[:drop_target].in?(VALID_DROP_TARGETS)
        @drop_target = params[:drop_target].to_sym
      else
        head :bad_request
      end
    end

    def perform_drop_action
      case @drop_target
      when :considering
        @card.reconsider
      when :on_deck
        @card.move_to_on_deck
      when :doing
        @card.engage
        if params[:stage_id].present?
          stage = Workflow::Stage.find(params[:stage_id])
          @card.change_stage_to(stage)
        end
      when :closed
        @card.close
      end
    end

    def render_column_replacement
      page_and_filter = page_and_filter_for @filter.with(engagement_status: @drop_target.to_s), per_page: CardsController::PAGE_SIZE

      if @drop_target == :doing && params[:stage_id].present?
        # For stage-specific doing columns, we need to render the specific stage
        stage = Workflow::Stage.find(params[:stage_id])
        render \
          turbo_stream: turbo_stream.replace("doing-cards-#{stage.id}",
          method: :morph,
          partial: "cards/index/engagement/doing",
          locals: { user_filtering: @user_filtering, **page_and_filter.to_h, stage: stage })
      else
        # For other columns, use the standard approach
        render \
          turbo_stream: turbo_stream.replace("#{@drop_target.to_s.gsub('_', '-')}-cards",
          method: :morph,
          partial: "cards/index/engagement/#{@drop_target}",
          locals: { user_filtering: @user_filtering, **page_and_filter.to_h })
      end
    end
end
