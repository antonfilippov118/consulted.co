# encoding: utf-8

module ApplicationHelper

  def determined_path(resource)
    if resource.sign_in_count == 1 && !resource.providers.nil?
      contact_email_path
    else
      overview_path
    end
  end

  def title!(value)
    @title = value
  end

  def default_title
    'Consulted - On-Demand Expert Marketplace'
  end

  def zopim?
    !Settings.platform_live? && Rails.env.production?
  end

  def synchronizing?
    current_page?(synchronisation_path)
  end
end
