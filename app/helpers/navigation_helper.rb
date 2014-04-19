module NavigationHelper
  def active_class(path)
    return 'active' if current_page? path
    ''
  end

  def show_signup?
    !user_signed_in? && !current_page?(new_user_registration_path) && !current_page?(new_user_session_path)
  end
end
