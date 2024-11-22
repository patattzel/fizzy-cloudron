class Assignments::TogglesController < ApplicationController
  include BubbleScoped, BucketScoped

  def create
    @bubble.toggle_assignment assignee
    redirect_to @bubble
  end

  private
    def assignee
      @bucket.users.active.find params.expect(:assignee_id)
    end
end
