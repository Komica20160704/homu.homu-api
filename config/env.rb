# frozen_string_literal: true

require 'bundler'
ENV['RACK_ENV'] ||= 'development'
Bundler.require
AwesomePrint.pry!
Time.zone = ActiveSupport::TimeZone.new('Taipei')
require_relative './credential'
Dir['./models/*.rb'].each { |model| require model }
