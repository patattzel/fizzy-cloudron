class Bubbles::ImagesController < ApplicationController
  include BubbleScoped, BucketScoped

  def destroy
    @bubble.image.purge_later
    redirect_to @bubble
  end
end
