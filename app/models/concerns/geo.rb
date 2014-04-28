module Geo
  module Continent
    extend ActiveSupport::Concern

    included do
      field :country, type: String
      field :continent
      field :region

      index country: 1
      index region: 1
      index continent: 1

      before_save do
        unless country.nil?
          country_obj    = Country.find_by_name country
          country_obj    = Country.new country_obj.first
          self.continent = country_obj.continent
          self.region    = country_obj.subregion
        end
      end
    end
  end
end
