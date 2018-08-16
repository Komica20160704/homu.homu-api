# frozen_string_literal: true

require './config/env'
require './app'
Thin::Logging.logger.level = Logger::Severity::DEBUG
ActiveRecord::Base.logger = Thin::Logging.logger
run Sinatra::Application
