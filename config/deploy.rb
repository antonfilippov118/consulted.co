lock '3.1.0'

set :application, 'consulted.co'
set :repo_url, 'git@github.com:floriank/consulted.git'
set :bundle_without, %w{development test deployment doc guard metrics benchmarks}.join(' ')

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/var/www/consulted.co'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{config/mongoid.yml config/thin.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  desc 'Restart application'
  task :restart do
     on roles(:app), in: :sequence, wait: 5 do
      within release_path do
        execute :bundle, "exec thin restart -O -C config/thin.yml"
      end
    end
  end

  after :publishing, :restart

  desc 'Copies assets from local compilation to current folder'
  task :copy_assets do
    file = 'assets.tar.gz'
    run_locally do
      execute 'cd ngapp && grunt && cd ..'
      execute "tar cvzf --exclude='.DS_Store' #{file} public"
    end

    on roles(:app) do
      upload! file, "#{release_path}/#{file}"
      execute "cd #{release_path} && tar xvzf #{file}"
      execute "rm #{release_path}/#{file}"
    end
  end

  before :publishing, :copy_assets
  before :restart, :bundler

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
