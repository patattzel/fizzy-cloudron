class ErrorsController < ApplicationController
  require_untenanted_access

  layout "error"

  def bad_request
    render status: :bad_request
  end

  def not_found
    render status: :not_found
  end

  def not_acceptable
    render status: :not_acceptable
  end

  def unprocessable_entity
    render status: :unprocessable_entity
  end

  def internal_server_error
    render status: :internal_server_error
  end
end
