class SearchController < ApplicationController
  include SearchHelper
  def show
  end

  def search
    find_experts
  end
end
