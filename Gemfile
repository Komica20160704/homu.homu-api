# frozen_string_literal: true

source 'https://rubygems.org'

ruby '2.5.0'

# Server App
gem 'rack'
gem 'sinatra', '~> 2.0.1'
gem 'sinatra-contrib', require: false
gem 'thin'
# Database
gem 'activerecord'
gem 'kaminari'
gem 'pg'
gem 'sinatra-activerecord'
# Library
gem 'activesupport', require: 'active_support/all'
gem 'json'
gem 'nokogiri'
gem 'rake'
# Helpful
gem 'awesome_print'
gem 'byebug'
gem 'pry'
gem 'rubocop'

group :test do
  gem 'rspec'
  gem 'webmock', require: 'webmock/rspec'
end

group :development do
  gem 'powder'
  gem 'puma'
end
