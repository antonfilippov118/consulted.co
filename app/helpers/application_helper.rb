# encoding: utf-8

module ApplicationHelper
  def analytics_key
    ENV['ANALYTICS_KEY']
  end
end
