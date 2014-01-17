# encoding: utf-8

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :null_session

  def after_sign_in_path_for(resource)
    profile
  end

  def after_sign_in_path_for(resource)
    profile
  end

  def after_sign_out_path_for(resource)
    root
  end

  private

  def profile
    '/#!/profile'
  end

  def root
    '/#!/'
  end
end
