RailsAdmin.config do |config|

  ### Popular gems integration

  ## == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :admin
  end

  config.current_user_method(&:current_admin)

  ## == Cancan ==
  # config.authorize_with :cancan

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  config.included_models = %w[User Group Admin PlatformSettings Investor]

  config.model User do
    list do
      field :name
      field :contact_email
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

  config.model Investor do
    label 'Closed beta users'
    list do
      field :email
      field :note
      field :sign_in_count
      field :last_sign_in_at
    end

    show do
      field :email
      field :note
    end

    edit do
      field :email
      field :password
      field :password_confirmation
      field :note
    end
  end

  config.model Group do
    list do
      field :name
      field :slug
      field :parent
      field :description
      field :seeker_gain
      field :seeker_expectation
      field :expert_background
      field :length_gain
    end

    edit do
      field :name
      field :description
      field :seeker_gain
      field :seeker_expectation
      field :expert_background
      field :length_gain
      field :parent
      field :children
      field :tags
    end

    show do
      field :name
      field :slug
      field :description
      field :seeker_gain
      field :seeker_expectation
      field :expert_background
      field :length_gain
      field :parent
      field :children
      field :tags
    end
  end

  config.model Admin do
    visible do
      bindings[:controller].current_admin.super_admin?
    end

    list do
      field :super_admin, :boolean
      field :email
    end

    edit do
      field :email, :string
      field :password
      field :password_confirmation
    end
  end

  config.model PlatformSettings do
    list do
      exclude_fields :'_id'
    end
  end

  config.actions do
    dashboard
    index

    new do
      except %w(PlatformSettings)
    end

    bulk_delete do
      except %w(PlatformSettings)
    end

    show
    edit

    delete do
      except %w(PlatformSettings)
    end

    show_in_app do
      hide do
        bindings[:object].is_a?(PlatformSettings) ||
        (bindings[:object].is_a?(Group) && bindings[:object].children?)
      end
    end

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end
