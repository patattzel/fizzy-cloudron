class Bubbles::StagingsController < ApplicationController
  include BubbleScoped, BucketScoped

  def create
    @bubble.toggle_stage Current.account.stages.find(params[:stage_id])
    redirect_to new_bucket_bubble_stage_picker_path(@bucket, @bubble)
  end
end
