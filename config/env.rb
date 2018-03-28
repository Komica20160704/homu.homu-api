ENV['RACK_ENV'] = 'production' if ENV['HOMU_DATABASE_PASSWORD'].present?
require 'sinatra/activerecord'
Dir['./models/*.rb'].each { |model| require model }
