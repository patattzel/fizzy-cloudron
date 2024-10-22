class Bubbles::StagePickersController < ApplicationController
  include BubbleScoped, BucketScoped

  before_action :set_workflows, :set_selected_workflow

  def new
  end

  private
    def set_workflows
      @workflows = Current.account.workflows
    end

    def set_selected_workflow
      @selected_workflow = if params[:workflow_id]
        @workflows.find params[:workflow_id]
      else
        @bubble.workflow || @workflows.first
      end
    end
end
