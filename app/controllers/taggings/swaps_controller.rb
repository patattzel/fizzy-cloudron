class Taggings::SwapsController < ApplicationController
  include BubbleScoped, BucketScoped

  def create
    @bubble.swap_tag incoming_tag, outgoing_tag
    redirect_to @bubble
  end

  private
    def incoming_tag
      if params[:incoming_tag_title]
        Tag.new title: params[:incoming_tag_title]
      else
        Current.account.tags.find params.expect(:incoming_tag_id)
      end
    end

    def outgoing_tag
      Current.account.tags.find params.expect(:outgoing_tag_id)
    end
end
