# encoding: utf-8

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery

  def after_sign_in_path_for(resource)
    search_path
  end

  def after_sign_in_path_for(resource)
    search_path
  end

  def after_sign_out_path_for(resource)
    root_path
  end

  #
  # TODO: remove this once the project goes live
  #
  USERS = { ENV['USER'] => ENV['PASSWORD'] }

  before_filter :authenticate

  def authenticate
    return true unless Rails.env.production?
    authenticate_or_request_with_http_digest("Consulted.co Platform") do |name|
      USERS[name]
    end
  end

end
