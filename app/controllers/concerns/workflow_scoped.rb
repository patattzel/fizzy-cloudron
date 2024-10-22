module WorkflowScoped
  extend ActiveSupport::Concern

  included do
    before_action :set_workflow
  end

  private
    def set_workflow
      @workflow = Current.account.workflows.find params[:workflow_id]
    end
end
