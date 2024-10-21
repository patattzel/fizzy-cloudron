class TagsController < ApplicationController
  include BucketScoped

  before_action :set_bubble, only: %i[ new create ]

  def index
    @tags = Current.account.tags.order(:title)
  end

  def new
  end

  # FIXME: Should move this to a taggings controller to separate tag administration from applying
  def create
    @bubble.tag(params.require(:tag).expect(:title))
    redirect_to @bubble
  end

  private
    def set_bubble
      @bubble = @bucket.bubbles.find(params[:bubble_id])
    end
end
