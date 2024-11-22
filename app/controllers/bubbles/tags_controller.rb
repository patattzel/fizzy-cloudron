class Bubbles::TagsController < ApplicationController
  include BubbleScoped, BucketScoped

  def index
    @tags = Current.account.tags.search params[:q]
  end
end
