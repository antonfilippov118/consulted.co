module Geo
  module Continent
    extend ActiveSupport::Concern

    included do
      field :country, type: Country
      field :continent
      field :region

      index country: 1
      index region: 1
      index continent: 1

      before_save do
        unless country.nil?
          self.continent = country.continent
          self.region    = country.subregion
        end
      end
    end
  end
end
