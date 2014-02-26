source 'https://rubygems.org'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.2'

gem 'bson_ext', platform: :ruby
gem 'jbuilder'
gem 'devise'
gem 'linkedin'

gem 'sass'
gem 'sass-rails', '>= 3.2' # sass-rails needs to be higher than 3.2
gem 'coffee-rails'
gem 'bootstrap-sass', '~> 3.1.1'
gem 'jquery-rails'
gem 'font-awesome-rails'
gem 'dragonfly'

group :deployment do
  gem 'capistrano'
  gem 'capistrano-rvm'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  gem 'capistrano-bower'
end

group :authentication do
  gem 'omniauth'
  gem 'omniauth-linkedin'
end

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :development do
  gem 'pry', '>= 0.9.12.4'
  gem 'pry-rails'
  gem 'thin'
end

group :test do
  gem 'rspec-rails'
  gem 'mongoid-rspec'
  gem 'database_cleaner'
end

group :db do
  gem 'mongoid', '~> 4.0.0.beta1'
  gem 'bson'
end

gem 'light-service'

# Added by devtools

group :development do
  gem 'rake',  '~> 10.1.0'
  gem 'rspec', '~> 2.14.1'
  gem 'yard',  '~> 0.8.7'

  gem 'rails_layout'

  platform :rbx do
    gem 'rubysl-singleton', '~> 2.0.0'
  end
end

group :yard do
  gem 'kramdown', '~> 1.3.0'
end

group :guard do
  gem 'guard',         '~> 2.2.4'
  gem 'guard-bundler', '~> 2.0.0'
  gem 'guard-rspec',   '~> 4.2.0'
  gem 'guard-rubocop', '~> 1.0.0'

  # file system change event handling
  gem 'listen',     '~> 2.4.0'
  gem 'rb-fchange', '~> 0.0.6', require: false
  gem 'rb-fsevent', '~> 0.9.3', require: false
  gem 'rb-inotify', '~> 0.9.0', require: false

  # notification handling
  # gem 'libnotify',               '~> 0.8.0', require: false
  # gem 'rb-notifu',               '~> 0.0.4', require: false
  # gem 'terminal-notifier-guard', '~> 1.5.3', require: false
end

group :metrics do
  gem 'coveralls', '~> 0.7.0'
  gem 'flay',      '~> 2.4.0'
  gem 'flog',      '~> 4.2.0'
  gem 'reek',      '~> 1.3.2'
  gem 'rubocop',   '~> 0.16.0'
  gem 'simplecov', '~> 0.8.2'
  gem 'yardstick', '~> 0.9.7', git: 'https://github.com/dkubb/yardstick.git'

  platforms :ruby_19, :ruby_20 do
    gem 'mutant',          '~> 0.3.0', git: 'https://github.com/mbj/mutant.git'
    gem 'unparser',        '~> 0.1.5', git: 'https://github.com/mbj/unparser.git'
    gem 'yard-spellcheck', '~> 0.1.5'
  end
end

group :benchmarks do
  gem 'rbench', '~> 0.2.3'
end
