class Taggings::TogglesController < ApplicationController
  include BubbleScoped, BucketScoped

  def create
    @bubble.toggle_tag tag
    redirect_to @bubble
  end

  private
    def tag
      if params[:tag_title]
        Tag.new title: params[:tag_title]
      else
        Current.account.tags.find params.expect(:tag_id)
      end
    end
end
