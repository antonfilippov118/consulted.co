# encoding: utf-8

require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
# require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'sprockets/railtie'
require 'rails/test_unit/railtie'
require 'mongoid'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Consulted
  class Application < Rails::Application
    # Use TorqueBox::Infinispan::Cache for the Rails cache store
    if defined? TorqueBox::Infinispan::Cache
      config.cache_store = :torquebox_store
    end

    config.generators do |g|
      g.test_framework :rspec
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run 'rake -D time' for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Europe/Berlin'

    I18n.enforce_available_locales = false

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :en

    config.assets.paths << Rails.root.join('vendor', 'assets', 'components')
  end
end
