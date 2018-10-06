# frozen_string_literal: true

require 'active_support/encrypted_configuration'

class Credential
  class << self
    attr_accessor :config, :encrypted_config
  end
  @encrypted_config = ActiveSupport::EncryptedConfiguration.new(
    config_path: './config/credentials.yml.enc',
    key_path: './config/master.key',
    env_key: 'API_HOMU_MASTER_KEY',
    raise_if_missing_key: true
  )
  @config = OpenStruct.new(YAML.safe_load(@encrypted_config.read))
end
