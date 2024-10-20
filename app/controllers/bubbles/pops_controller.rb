class Bubbles::PopsController < ApplicationController
  include BubbleScoped, BucketScoped

  def create
    @bubble.pop!
    redirect_to bucket_bubble_path(@bubble.bucket, @bubble)
  end

  def destroy
    @bubble.unpop
    redirect_to bucket_bubble_path(@bubble.bucket, @bubble)
  end
end
