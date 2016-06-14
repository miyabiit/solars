# config valid only for current version of Capistrano
lock '3.4.1'

set :application, 'solars'
set :repo_url, 'git@github.com:shallontecbiz/solars.git'

set :deploy_to, "/home/ec2-user/node_apps/solars"

ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

set :keep_releases, 3

set :rbenv_type, :user
set :rbenv_ruby, '2.3.1'
set :rbenv_path, "/usr/local/rbenv"
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby}
set :rbenv_roles, :all # default value

set :bundle_gemfile, -> { release_path.join('crawler', 'Gemfile') }
set :bundle_path, -> { shared_path.join('crawler', 'vendor', 'bundle') }  
set :bundle_without,  [:development, :test]
set :bundle_env_variables, { nokogiri_use_system_libraries: 1 }

set :user, "ec2-user"
set :group, "ec2-user"

set :app_server_path, "#{current_path}/web/server"
set :crawler_path, "#{current_path}/crawler"

set :ssh_options, {
  user: 'ec2-user',
  forward_agent: true
}

set :nvm_type, :user # or :system, depends on your nvm setup
set :nvm_node, 'v0.12.0'
set :nvm_map_bins, %w{node npm bower forever}

set :npm_target_path, -> { release_path.join('web') }
set :npm_flags, '--production --silent --no-progress'
set :npm_roles, :all
set :npm_env_variables, {}

set :bower_flags, '--quiet --config.interactive=false'
set :bower_roles, :web
set :bower_target_path, -> { release_path.join('web') }
set :bower_bin, :bower

set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }

set :linked_dirs, %w{log web/node_modules crawler/vendor/bundle}

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

set :node_env, (fetch(:node_env) || fetch(:stage))
set :default_env, { node_env: fetch(:node_env) }

# Default value for keep_releases is 5
# set :keep_releases, 5

#namespace :deploy do
#
#  after :restart, :clear_cache do
#    on roles(:web), in: :groups, limit: 3, wait: 10 do
#      # Here we can do anything such as:
#      # within release_path do
#      #   execute :rake, 'cache:clear'
#      # end
#    end
#  end
#end

namespace :deploy do
 
  desc 'Start application'
  task :start do
    on roles(:app) do
      within current_path do
        execute :forever, 'start',  "#{fetch(:app_server_path)}/app.js"
      end
    end
  end
 
  desc 'Stop application'
  task :stop do
    on roles(:app) do
      within current_path do
        execute :forever, 'stopall'
      end
    end
  end
 
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      within current_path do
        execute :forever, 'stopall'
        execute :forever, 'start', "#{fetch(:app_server_path)}/app.js"
      end
    end
  end
 
  after :publishing, :restart

  desc 'update crontab by config/schedule.rb'
  task :update_schedule do
    on roles(:app) do
      within fetch(:crawler_path) do
        execute :bundle, 'exec', 'whenever', '--update-crontab', fetch(:whenever_identifier), '--set', "environment=#{fetch(:stage)}", "--roles=app"
      end
    end
  end

  after :finished, :update_schedule
end
