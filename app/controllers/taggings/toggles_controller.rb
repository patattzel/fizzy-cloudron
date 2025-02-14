class Taggings::TogglesController < ApplicationController
  include BubbleScoped, BucketScoped

  def create
    if params[:tag_title].present?
      sanitized_title = params[:tag_title].strip.gsub(/\A#/, "")
      tag = Current.account.tags.find_or_create_by!(title: sanitized_title)
      @bubble.toggle_tag(tag)
    else
      new_tag_ids = Array(params[:tag_id])
      current_tags = @bubble.tags

      current_tags.each do |tag|
        @bubble.toggle_tag(tag) unless new_tag_ids.include?(tag.id.to_s)
      end

      new_tag_ids.each do |id|
        tag = Current.account.tags.find(id)
        @bubble.toggle_tag(tag) unless current_tags.include?(tag)
      end
    end

    redirect_to @bubble
  end
end
