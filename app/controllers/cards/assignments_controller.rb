class Cards::AssignmentsController < ApplicationController
  include CardScoped

  def new
  end

  def create
    @card.toggle_assignment @collection.users.active.find(params[:assignee_id])
    render turbo_stream: turbo_stream.replace([ @card, :meta ], partial: "/cards/display/perma/meta", method: "morph", locals: { card: @card.reload })
  end
end
