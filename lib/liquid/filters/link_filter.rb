module LinkFilter
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::TagHelper

  # TODO: refactoring needed

  def link_to_confirmation(link_text, resource_id, token)
    link_to(link_text, confirmation_url(resource_id, token))
  end

  def link_to_edit_password(link_text, resource_id, token)
    link_to(link_text, edit_password_url(resource_id, token))
  end

  def link_to_admin(link_text)
    link_to(link_text, admin_url)
  end

  def link_to(link_text, url)
    content_tag :a, link_text, href: url, title: link_text
  end

  def confirmation_url(text = '', resource_id, token)
    user_confirmation_url(resource_id, confirmation_token: token)
  end

  def edit_password_url(text = '', resource_id, token)
    edit_user_password_url(resource_id, reset_password_token: token)
  end

  def admin_url(text = '')
    rails_admin_url
  end

  private

  def default_url_options
    ActionMailer::Base.default_url_options
  end
end
