module AuthenticationController
  extend ActiveSupport::Concern

  def admin?(request)
    !(request.path =~ /admin/i).nil?
  end

  def live?
    Settings.platform_live?
  end

  included do
    def authenticate!
      return true if live?
      return true if admin? request

      if current_investor.nil?
        redirect_to new_investor_session_path
      end
    end
    before_filter :authenticate!
  end
end
