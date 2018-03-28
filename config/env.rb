require 'sinatra/activerecord'
Dir['./models/*.rb'].each { |model| require model }
