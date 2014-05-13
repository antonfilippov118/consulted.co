class CkAssetsController < ApplicationController
  def index
    begin
      ck_path = "/assets/#{Rails.application.assets[params[:ck_asset_name]].digest_path}"
    rescue
      ck_path = root_path
    end
    redirect_to ck_path
  end
end
