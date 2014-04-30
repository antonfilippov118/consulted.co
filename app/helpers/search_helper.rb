module SearchHelper
  def search_params
    params.permit :text, :group, :bookmark, :rate_lower, :rate_upper, :experience_lower, :experience_upper, continents: [], languages: []
  end
end
