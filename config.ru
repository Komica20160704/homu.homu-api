map('/') do
  require './chat'
  run Sinatra::Application
end

