source 'https://rubygems.org'

ruby '~> 2.5.0'

# Server App
gem 'sinatra', '~> 2.0.1'
gem 'sinatra-contrib'
gem 'rack'
gem 'thin'
# Database
gem 'sinatra-activerecord'
gem 'activerecord'
gem 'pg'
# Library
gem 'activesupport', require: 'active_support/all'
gem 'rake'
gem 'json'
gem 'nokogiri'
gem 'byebug'

group :test do
  gem 'rspec'
  gem 'webmock', require: 'webmock/rspec'
end

group :development do
  gem 'puma'
  gem 'powder'
end
