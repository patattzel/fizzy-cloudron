class SearchesController < ApplicationController
  before_action :set_query_terms

  def show
    @search_results = Current.user.search(@query_terms).limit(50)
    @recent_search_queries = Current.user.search_queries.order(created_at: :desc).limit(10)
  end

  private
    def set_query_terms
      @query_terms = params[:q]
    end
end
