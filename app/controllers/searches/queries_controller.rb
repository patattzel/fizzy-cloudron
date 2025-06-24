class Searches::QueriesController < ApplicationController
  def create
    Current.user.remember_search(terms_params)
    head :ok
  end

  private
    def terms_params
      params[:terms]
    end
end
