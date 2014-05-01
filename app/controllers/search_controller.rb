class SearchController < ApplicationController
  include SearchHelper
  def show
    title! 'Find an expert'
  end

  def search
    result  = FindsOffers.for search_params, @user
    @offers = result.fetch :offers
  end
end
