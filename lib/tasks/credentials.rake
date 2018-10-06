# frozen_string_literal: true

namespace :credentials do
  desc 'Edit credential'
  task :edit do
    Credential.encrypted_config.change do |temp_file|
      editor = ENV.fetch('EDITOR') { 'vim' }
      system(editor, temp_file.to_s)
    end
  end

  desc 'Show credential'
  task :show do
    puts Credential.encrypted_config.read
  end
end
