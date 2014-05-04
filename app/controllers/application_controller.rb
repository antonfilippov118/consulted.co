# encoding: utf-8

class ApplicationController < ActionController::Base
  include ApplicationHelper
  #
  # TODO
  # Remove this helper, once the application goes into open beta
  #
  include AuthenticationController

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery

  protected

  def verified_request?
    super || form_authenticity_token == request.headers['X-XSRF-TOKEN']
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
