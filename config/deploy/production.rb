set :application, "POS Api"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/app/pos_api"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
default_run_options[:pty] = true
ssh_options[:forward_agent] = true
set :scm, :git
set :repository, "git@github.com:rarolabs/pos.git"
set :branch, "master"
#set :deploy_via, :remote_cache
set :git_shallow_clone, 1
set :use_sudo, false

#set :scm_verbose, true
set :copy_cache, true
set :keep_releases, 5

set :user, 'ubuntu'
set :ssh_options, { :forward_agent => true }

set :rails_env do
  "production"
end

role :app, "177.71.250.92"
role :web, "177.71.250.92"
role :db,  "177.71.250.92", :primary => true

load 'deploy/assets'


namespace :deploy do
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
end
#para rodar o bundle antes do assets https://github.com/capistrano/capistrano/issues/81
before "deploy:assets:precompile", :bundle_install

task :bundle_install, :roles => :app do
  run "cd #{release_path} && bundle install"
end

#after 'deploy:update_code' do
#  run "cd #{release_path}; RAILS_ENV=production /home/raro/.rvm/wrappers/ruby-1.9.2-p290/rake assets:precompile"
#end