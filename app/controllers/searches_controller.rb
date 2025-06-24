class SearchesController < ApplicationController
  def show
    @search_results = Current.user.search(query_param).limit(50)
    @recent_search_queries = Current.user.search_queries.order(created_at: :desc).limit(10)
  end

  private
    def query_param
      params[:q]
    end
end
