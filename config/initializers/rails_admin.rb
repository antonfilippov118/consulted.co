RailsAdmin.config do |config|

  ### Popular gems integration

  ## == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :admin
  end

  config.current_user_method(&:current_admin)

  # TODO: maybe somehow we can use rails url helper here?
  config.navigation_static_links = {
    'Log out' => '/admins/sign_out'
  }

  ## == Cancan ==
  # config.authorize_with :cancan

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  config.included_models = %w[User Group]

  config.model User do
    list do
      field :profile_image
      field :name
      field :email
      field :status
    end

    edit do
      field :profile_image
      field :name
      field :email, :string

      field :status, :enum do
        enum do
          User::STATUS_LIST
        end
      end

      field :password
      field :password_confirmation
    end

    show do
      field :profile_image
      field :name
      field :email
      field :status
    end
  end

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    # export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end
