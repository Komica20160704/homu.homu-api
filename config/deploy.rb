# frozen_string_literal: true

lock '~> 3.11.0'

set :application, 'api-homu'
set :repo_url, 'https://github.com/Komica20160704/homu.homu-api'
set :deploy_to, '/home/api-homu'
append :linked_files, 'config/database.yml'
append :linked_dirs, '.bundle', 'log', 'tmp/pids'
append :bundle_bins, 'thin'
set :keep_releases, 2

namespace :thin do
  commands = %i[start stop restart]

  def thin_server(command, config_file)
    execute :bundle, 'exec', :thin, command, "--config #{config_file}"
  end

  commands.each do |command|
    task command do
      on roles :app do
        within current_path do
          thin_server(command, 'config/thin.yml')
        end
      end
    end
  end

  task :hot_reload do
    on roles :app do
      within current_path do
        config_file = 'config/thin.yml'
        hot_reload_config_file = 'config/thin_hot_reload.yml'
        thin_server(:start, hot_reload_config_file)
        thin_server(:stop, config_file)
        thin_server(:start, config_file)
        thin_server(:stop, hot_reload_config_file)
      end
    end
  end
end

before 'deploy:published', 'thin:hot_reload'
