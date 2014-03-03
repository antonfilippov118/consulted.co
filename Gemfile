source 'https://rubygems.org'
ruby '2.0.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.2'

gem 'bson_ext'
gem 'rabl'
gem 'multi_json'
gem 'devise'
gem 'linkedin'

gem 'sass'
gem 'sass-rails', '>= 3.2' # sass-rails needs to be higher than 3.2
gem 'coffee-rails'
gem 'bootstrap-sass', '~> 3.1.1'
gem 'jquery-rails'
gem 'font-awesome-rails'
gem 'dragonfly'
gem 'dragonfly-s3_data_store'
gem 'light-service'
gem 'uglifier'
gem 'mongoid_slug'

group :production do
  gem 'unicorn'
  gem 'rails_serve_static_assets'
  gem 'rails_12factor'
  gem 'heroku-deflater'
  gem 'newrelic_rpm'
end

group :authentication do
  gem 'omniauth'
  gem 'omniauth-linkedin'
end

group :db do
  gem 'mongoid', '~> 4.0.0.beta1'
  gem 'bson'
end

group :development do
  gem 'pry', '>= 0.9.12.4'
  gem 'pry-rails'

  gem 'rake',  '~> 10.1.0'
  gem 'rspec', '~> 2.14.1'
  gem 'yard',  '~> 0.8.7'

  gem 'rails_layout'

  gem 'thin'

  gem 'foreman'

  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
  gem 'kramdown', '~> 1.3.0'

  gem 'guard',         '~> 2.2.4'
  gem 'guard-bundler', '~> 2.0.0'
  gem 'guard-rspec',   '~> 4.2.7'
  gem 'guard-rubocop', '~> 1.0.2'
  # file system change event handling
  gem 'listen',     '~> 2.4.0'
  gem 'rb-fchange', '~> 0.0.6', require: false
  gem 'rb-fsevent', '~> 0.9.3', require: false
  gem 'rb-inotify', '~> 0.9.0', require: false
  # notification handling
  gem 'libnotify',               '~> 0.8.0', require: false
  gem 'rb-notifu',               '~> 0.0.4', require: false
  gem 'terminal-notifier-guard', '~> 1.5.3', require: false

  gem 'coveralls', '~> 0.7.0'
  gem 'flay',      '~> 2.4.0'
  gem 'flog',      '~> 4.2.0'
  gem 'reek',      '~> 1.3.2'
  gem 'rubocop',   '~> 0.18.1'
  gem 'simplecov', '~> 0.8.2'
  gem 'yardstick', '~> 0.9.7', git: 'https://github.com/dkubb/yardstick.git'
end

group :test do
  gem 'rspec-rails'
  gem 'mongoid-rspec'
  gem 'database_cleaner'
end
