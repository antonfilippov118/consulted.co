class Fonts::FlaticonController < ApplicationController
  respond_to :woff, :ttf, :eot, :svg
  def show
    send_file font_file
  end

  private

  def font_file
    Rails.root.join('app', 'assets', 'fonts', "flaticon.#{format}")
  end

  def format
    params[:format] || 'woff'
  end
end
