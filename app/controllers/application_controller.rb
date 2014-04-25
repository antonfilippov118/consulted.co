# encoding: utf-8

class ApplicationController < ActionController::Base
  include ApplicationHelper
  #
  # TODO
  # Remmove this helper, once the application goes live
  #
  include AuthenticationHelper
  #before_filter :authenticate!, except: [:handle, :lookup], if: -> { Rails.env.production? }

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery

  def after_sign_in_path_for(resource)
    determined_path resource
  end

  def after_sign_out_path_for(resource)
    root_path
  end

  private

  before_filter :make_action_mailer_use_request_host_and_protocol
  before_filter :user!
  before_filter :set_timezone
  def make_action_mailer_use_request_host_and_protocol
    ActionMailer::Base.default_url_options[:protocol] = request.protocol
    ActionMailer::Base.default_url_options[:host] = request.host_with_port
  end

  def user!
    @user = current_user
  end

  def set_timezone
    Time.zone = @user.timezone unless @user.nil?
  end

  after_filter :set_csrf_cookie

  def set_csrf_cookie
    if protect_against_forgery?
      cookies['XSRF-TOKEN'] = form_authenticity_token
    end
  end
end
