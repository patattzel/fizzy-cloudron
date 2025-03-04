class Bubbles::PinsController < ApplicationController
  include BubbleScoped, BucketScoped

  def show
  end

  def create
    @bubble.set_pinned(Current.user, true)
    redirect_to bucket_bubble_pin_path(@bucket, @bubble)
  end

  def destroy
    @bubble.set_pinned(Current.user, false)
    redirect_to bucket_bubble_pin_path(@bucket, @bubble)
  end
end
