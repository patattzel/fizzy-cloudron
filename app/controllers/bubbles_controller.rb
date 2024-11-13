class BubblesController < ApplicationController
  include BucketScoped

  skip_before_action :set_bucket, only: :index

  before_action :set_filter, only: :index
  before_action :set_bubble, only: %i[ show edit update ]

  def index
    @bubbles = @filter.bubbles
    @bubbles = @bubbles.mentioning(params[:term]) if params[:term].present?
  end

  def create
    @bubble = @bucket.bubbles.create!
    redirect_to @bubble
  end

  def show
    fresh_when etag: @bubble
  end

  def edit
  end

  def update
    @bubble.update! bubble_params

    if turbo_frame_request?
      if params[:bubble][:due_on].present?
        render "bubbles/date_pickers/show"
      else
        render :show
      end
    else
      redirect_to @bubble
    end
  end

  private
    def set_filter
      @filter = Current.user.filters.build params.permit(*Filter::KNOWN_PARAMS)
    end

    def set_bubble
      @bubble = @bucket.bubbles.find params[:id]
    end

    def bubble_params
      params.expect(bubble: [ :title, :color, :due_on, :image, tag_ids: [] ])
    end
end
