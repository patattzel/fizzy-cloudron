class Collections::WorkflowsController < ApplicationController
  include CollectionScoped

  before_action :set_workflow

  def update
    @collection.update! workflow: @workflow
    render turbo_stream: turbo_stream.replace([ @collection, :workflows ], partial: "collections/edit/workflows", locals: { collection: @collection })
  end

  private
    def set_workflow
      @workflow = Workflow.find(params[:collection][:workflow_id])
    end
end
