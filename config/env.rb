require 'bundler'
if ENV['HOMU_DATABASE_PASSWORD']
  ENV['RACK_ENV'] = 'production'
else
  ENV['RACK_ENV'] ||= 'development'
end
Bundler.require
AwesomePrint.irb!
AwesomePrint.pry!
Time.zone = ActiveSupport::TimeZone.new('Taipei')
Dir['./models/*.rb'].each { |model| require model }
