class Cards::StagingsController < ApplicationController
  include CardScoped

  def update
    stage = @collection.workflow.stages.find(params[:stage_id])

    if @card.considering?
      @card.engage
    end

    @card.change_stage_to(stage)
    render_card_replacement
  end
end
