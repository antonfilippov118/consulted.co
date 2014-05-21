# This file is used by Rack-based servers to start the application.
require 'rack/cors'

use Rack::Cors do
  allow do
    origins '*'
    resource '/assets/*', headers: :any, methods: :get
  end
end

require ::File.expand_path('../config/environment',  __FILE__)
run Rails.application
