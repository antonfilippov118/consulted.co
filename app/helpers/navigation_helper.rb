module NavigationHelper
  def active_class(path)
    return 'active' if current_page? path
    ''
  end

  def show_signup?
    return false if !(controller_path =~ /admins/).nil?
    !user_signed_in? && !current_page?(new_user_registration_path) && !current_page?(new_user_session_path)
  end

  def login_view?
    registrations = controller_name == 'registrations' && action_name == 'create'
    login         = controller_name == 'sessions' && action_name == 'create'
    pages = [
      new_user_registration_path,
      new_user_session_path
    ].map do |page|
      current_page? page
    end

    pages.include?(true) || login || registrations
  end
end
