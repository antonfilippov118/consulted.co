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

  private

  before_filter :make_action_mailer_use_request_host_and_protocol
  before_filter :user?
  def make_action_mailer_use_request_host_and_protocol
    ActionMailer::Base.default_url_options[:protocol] = request.protocol
    ActionMailer::Base.default_url_options[:host] = request.host_with_port
  end

  def user?
    @user = current_user
  end

  #
  # TODO: remove this once the project goes live
  #
  USERS = { ENV['USER'] => ENV['PASSWORD'] }

  before_filter :authenticate

  def authenticate
    return true unless Rails.env.production?
    authenticate_or_request_with_http_digest('Consulted.co Platform') do |name|
      USERS[name]
    end
  end
end
