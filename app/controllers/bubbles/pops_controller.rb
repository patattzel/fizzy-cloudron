class Bubbles::PopsController < ApplicationController
  include BubbleScoped, BucketScoped

  def create
    @bubble.pop!(user: Current.user)
    redirect_to @bubble
  end

  def destroy
    @bubble.unpop
    redirect_to @bubble
  end
end
