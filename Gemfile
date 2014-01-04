source 'https://rubygems.org'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.2'

gem 'rabl'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :server do
  gem 'torquebox', '3.0.1'
  gem 'torquebox-server', '3.0.1'
end

group :development do
  gem 'pry', '>= 0.9.12.4'
  gem 'pry-rails'
end

group :development, :test do
  gem 'devtools', git: 'https://github.com/rom-rb/devtools.git'
  gem 'jruby-lint', platform: :jruby
end

group :test do
  gem 'rspec-rails'
  gem 'mongoid-rspec'
end

group :db do
  gem 'mongoid', '~> 4.0.0.alpha1'
  gem 'bson'
end

group :security do
  gem 'bcrypt-ruby'
end

gem 'light-service'

# Added by devtools
eval_gemfile 'Gemfile.devtools'
