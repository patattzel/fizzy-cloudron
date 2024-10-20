class Bubbles::ImagesController < ApplicationController
  include BubbleScoped, BucketScoped

  def destroy
    @bubble.image.purge_later
    redirect_to bucket_bubble_path(@bubble.bucket, @bubble)
  end
end
