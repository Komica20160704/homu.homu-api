map('/') do
  require './app'
  run Sinatra::Application
end
