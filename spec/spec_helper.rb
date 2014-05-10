# encoding: utf-8

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'mongoid'
require 'rspec/rails'
require 'rspec/autorun'
require 'turnip/capybara'
require 'consulted/test_helpers'
require 'email_spec'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join('spec/**/{support,step_definitions}/**/*.rb')].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

OmniAuth.config.test_mode = true
OmniAuth.config.mock_auth[:linkedin] = {
  provider: 'linkedin',
  uid: '123456',
  info: {
    name: 'Florian'
  }
}

RSpec.configure do |conf|
  conf.include Mongoid::Matchers, type: :model
  conf.include Devise::TestHelpers, type: :controller
  conf.include Consulted::TestHelpers

  conf.include Rails.application.routes.url_helpers
  conf.include FactoryGirl::Syntax::Methods

  conf.include EmailSpec::Helpers
  conf.include EmailSpec::Matchers

  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # conf.mock_with :mocha
  # conf.mock_with :flexmock
  # conf.mock_with :rr

  conf.before(:suite) do
    DatabaseCleaner[:mongoid].strategy = :truncation
  end

  conf.before(:each) do
    ActionMailer::Base.deliveries.clear
    DatabaseCleaner[:mongoid].start
    Consulted::TestHelpers::EmailTemplates.create!
  end

  conf.after(:each) do
    DatabaseCleaner[:mongoid].clean
    EmailTemplate.delete_all
  end

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This attr_writer :attr_namesill be the default behavior in future versions of
  # rspec-rails.
  conf.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  conf.order = 'random'
end
