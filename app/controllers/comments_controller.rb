class CommentsController < ApplicationController
  include BubbleScoped, BucketScoped

  def create
    @bubble.capture new_comment
    redirect_to @bubble
  end

  private
    def new_comment
      Comment.new params.expect(comment: [ :body ])
    end
end
