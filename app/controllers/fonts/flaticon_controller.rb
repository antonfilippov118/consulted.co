class Fonts::FlaticonController < ApplicationController
  respond_to :woff, :ttf, :eot, :svg
  def show
    response.headers['Expires'] = cache_time.from_now.httpdate
    response.headers['Etag'] = Digest::SHA1.hexdigest(font_file.path)
    expires_in cache_time, public: true
    send_file font_file
  end

  private

  def font_file
    File.new(Rails.root.join('app', 'assets', 'fonts', "flaticon.#{format}"), 'r')
  end

  def format
    params[:format] || 'woff'
  end

  def cache_time
    30.days
  end
end
