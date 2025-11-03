class Webhooks::ActivationsController < ApplicationController
  before_action :ensure_admin
  before_action :set_webhook

  def create
    @webhook.activate unless @webhook.active?
    redirect_to @webhook
  end

  private
    def set_webhook
      @webhook = Webhook.find(params[:webhook_id])
    end
end
