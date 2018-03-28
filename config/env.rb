require 'sinatra/activerecord'
ENV['RACK_ENV'] = 'production' if ENV['HOMU_DATABASE_PASSWORD'].present?
Dir['./models/*.rb'].each { |model| require model }
