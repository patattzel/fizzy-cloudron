class Assignments::TogglesController < ApplicationController
  include BubbleScoped, BucketScoped

  def create
    new_assignee_ids = Array(params[:assignee_id])
    current_assignees = @bubble.assignees

    current_assignees.each do |assignee|
      @bubble.toggle_assignment(assignee) unless new_assignee_ids.include?(assignee.id.to_s)
    end

    new_assignee_ids.each do |id|
      assignee = @bucket.users.active.find(id)
      @bubble.toggle_assignment(assignee) unless current_assignees.include?(assignee)
    end

    redirect_to @bubble
  end

  private
    def assignee
      @bucket.users.active.find params[:assignee_id]
    end
end
