class Users::UtilitiesController < ApplicationController
  def region
    render json: Settings.continents
  end
end
