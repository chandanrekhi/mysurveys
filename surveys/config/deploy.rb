
require 'bundler/capistrano'
require 'capistrano/ext/multistage'

# config valid only for Capistrano 3.1
#lock '3.2.1'

set :application, 'Surveys'
set :repository, 'https://github.com/chandanrekhi/mysurveys.git'


# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
 set :deploy_to, '/var/www/mysurveys'

# Default value for :scm is :git
default_run_options[:pty] = true

set :user, 'ruby'
set :use_sudo, 'false'
set :scm, :git
set :deploy_via, :export
set :scm_passphrase, "unf0ld"
set :stages, %w(production staging preprod)

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  #desc 'Restart application'
  #task :restart do
   # on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
    #end
  #end

 # after :publishing, :restart

  #after :restart, :clear_cache do
  #  on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    #end
  #end

desc 'Start the Thin process'
  task :start, :roles => :app do
    run "cd #{current_path}; bundle exec thin start -C #{thin_config}"
  end
  
  desc 'Stop the Thin process'
  task :stop, :roles => :app do
    run "cd #{current_path}; bundle exec thin stop -C #{thin_config}"
  end
  
  desc 'Restart the Thin process'
  task :restart, :roles => :app do
    run "cd #{current_path}; bundle exec thin stop -C #{thin_config}"
    run "cd #{current_path}; bundle exec thin start -C #{thin_config}"
    run "#{sudo} monit restart apache"
  end
end

after 'db:recreate', 'deploy:restart'

# deploy:restart dependencies
after 'deploy:restart', 'deploy:cleanup'