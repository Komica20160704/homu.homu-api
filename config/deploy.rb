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

  commands.each do |command|
    task command do
      on roles :app do
        within current_path do
          config_file = 'config/thin.yml'
          execute :bundle, 'exec', :thin, command, "--config #{config_file}"
        end
      end
    end
  end
end

before 'deploy:published', 'docker:restart'
