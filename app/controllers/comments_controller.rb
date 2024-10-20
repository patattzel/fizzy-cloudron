class CommentsController < ApplicationController
  include BubbleScoped, BucketScoped

  def create
    @bubble.comments.create! body: params.expect(comment: [ :body ])
    redirect_to @bubble
  end
end
