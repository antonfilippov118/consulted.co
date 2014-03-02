require 'dragonfly'
require 'dragonfly/s3_data_store'

# Configure
Dragonfly.app.configure do
  plugin :imagemagick
  protect_from_dos_attacks true
  secret '4a3c037dce62fc552e8a69aa931ebbc0f9865f137caa28b487b9d26c5cd60a17'

  url_format '/media/:job/:name'

  case Rails.env
  when 'production'
    datastore :s3,
              bucket_name: 'consulted-images',
              access_key_id: ENV['AWS_ACCESS_KEY'],
              secret_access_key: ENV['AWS_ACCESS_SECRET']
  else
    datastore :file,
              root_path: Rails.root.join('public/system/dragonfly', Rails.env),
              server_root: Rails.root.join('public')
  end
end

# Logger
Dragonfly.logger = Rails.logger

# Mount as middleware
Rails.application.middleware.use Dragonfly::Middleware
