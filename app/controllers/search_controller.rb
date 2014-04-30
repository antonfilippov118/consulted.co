class SearchController < ApplicationController
  include SearchHelper
  def show
    title! 'Find an expert'
  end

  def search
    result  = FindsOffers.for search_params, current_user
    @offers = result.fetch :offers
  end

  private

  def search_params
    params.permit :group, :bookmark, :rate_lower, :rate_upper, :experience_lower, :experience_upper, continents: [], languages: []
  end
end
