class Assignments::SwapsController < ApplicationController
  include BubbleScoped, BucketScoped

  def create
    @bubble.swap_assignment incoming_assignee, outgoing_assignee
    redirect_to @bubble
  end

  private
    def incoming_assignee
      @bucket.users.active.find params.expect(:incoming_assignee_id)
    end

    def outgoing_assignee
      @bucket.users.active.find params.expect(:outgoing_assignee_id)
    end
end
