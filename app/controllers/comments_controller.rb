class CommentsController < ApplicationController
  include BubbleScoped, BucketScoped

  def create
    @bubble.comment! params.expect(comment: [ :body ])
    redirect_to bucket_bubble_path(@bucket, @bubble)
  end
end
