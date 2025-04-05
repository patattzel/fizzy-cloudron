module BubbleScoped
  extend ActiveSupport::Concern

  included do
    before_action :set_bubble, :set_bucket
  end

  private
    def set_bubble
      @bubble = Bubble.find(params[:bubble_id])
    end

    def set_bucket
      @bucket = Current.user.buckets.find(@bubble.bucket_id)
    end
end
