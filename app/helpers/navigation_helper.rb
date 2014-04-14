module NavigationHelper
  def active_class(path)
    return 'active' if current_page? path
    ''
  end
end
