class Account::TagsController < ApplicationController
  before_action :ensure_admin
  before_action :set_tag

  def update
    if sanitized_title.blank?
      redirect_to account_settings_path(anchor: "tags"), alert: "Tag name can't be blank"
      return
    end

    if @tag.update(title: sanitized_title)
      redirect_to account_settings_path(anchor: "tags"), notice: "Tag renamed"
    else
      redirect_to account_settings_path(anchor: "tags"), alert: @tag.errors.full_messages.to_sentence
    end
  end

  def destroy
    if @tag.destroy
      redirect_to account_settings_path(anchor: "tags"), notice: "Tag deleted"
    else
      redirect_to account_settings_path(anchor: "tags"), alert: @tag.errors.full_messages.to_sentence
    end
  end

  private
    def set_tag
      @tag = Current.account.tags.find(params[:id])
    end

    def sanitized_title
      params.expect(tag: :title).fetch(:title, "").strip.gsub(/\A#/, "")
    end
end
