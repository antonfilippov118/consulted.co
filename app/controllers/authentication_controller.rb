module AuthenticationController
  extend ActiveSupport::Concern

  included do
    def authenticate!
      unless current_investor
        redirect_to new_investor_session_path
      end
    end

    before_filter :authenticate!

  end
end
