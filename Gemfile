source 'https://rubygems.org'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.2'

group :template do
  gem 'rabl'
end

gem 'bson_ext', platform: :ruby
gem 'devise'
gem "linkedin"

group :deployment do
  gem 'capistrano'
  gem 'capistrano-rvm'
  gem 'capistrano-bundler'
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
end

group :development, :test do
  gem 'devtools', git: 'https://github.com/rom-rb/devtools.git'
end

group :test do
  gem 'rspec-rails'
  gem 'mongoid-rspec'
end

group :db do
  gem 'mongoid', '~> 4.0.0.alpha1'
  gem 'bson'
end

gem 'light-service'

# Added by devtools

group :development do
  gem 'rake',  '~> 10.1.0'
  gem 'rspec', '~> 2.14.1'
  gem 'yard',  '~> 0.8.7'

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
  gem 'libnotify',               '~> 0.8.0', require: false
  gem 'rb-notifu',               '~> 0.0.4', require: false
  gem 'terminal-notifier-guard', '~> 1.5.3', require: false
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

  platform :rbx do
    gem 'json',               '~> 1.8.1'
    gem 'racc',               '~> 1.4.10'
    gem 'rubysl-logger',      '~> 2.0.0'
    gem 'rubysl-open-uri',    '~> 2.0.0'
    gem 'rubysl-prettyprint', '~> 2.0.2'
  end
end

group :benchmarks do
  gem 'rbench', '~> 0.2.3'
end

platform :jruby do
  group :jruby do
    gem 'jruby-openssl', '~> 0.8.5'
  end
  gem 'torquebox', '3.0.1'
  gem 'torquebox-server', '3.0.1'
end

platform :ruby do
  gem 'thin'
end

