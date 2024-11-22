class Bubbles::UsersController < ApplicationController
  include BubbleScoped, BucketScoped

  def index
    @users = @bucket.users.active.search params[:q]
  end
end
