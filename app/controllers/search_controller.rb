class SearchController < ApplicationController
  include SearchHelper
  def show
    title! 'Find an expert'
  end

  def search
    result = FindsOffers.for search_params, current_user
    @experts = result.fetch :experts
  end

  private

  def search_params
    params.permit :group, :continents, :languages, :bookmark
  end
end
