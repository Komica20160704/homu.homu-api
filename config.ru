require 'rack/lobster'
require './Domain/HomuGetter'
require './Domain/HomuBlockParser'

map '/homu' do
  homu = '[ '
  homuGetter = HomuGetter.new
  homuGetter.DownloadHtml 0
  homuGetter.CutHtml
  parser = HomuBlockParser.new homuGetter.Contents
  blocks = homuGetter.Blocks
  blocks.each do |block|
    homu += parser.Parse block
    if block == blocks.last
      homu += ' ]'
    else
      homu += ', '
    end
  end
  get_json = proc do |env|
    [200, { "Content-Type" => "text/html" }, [homu]]
  end
  run get_json
end

map '/health' do
  health = proc do |env|
    [200, { "Content-Type" => "text/html" }, ["1"]]
  end
  run health
end

map '/lobster' do
  run Rack::Lobster.new
end

map '/' do
  welcome = proc do |env|
    [200, { "Content-Type" => "text/html" }, [<<WELCOME_CONTENTS
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
  <title>Welcome to OpenShift</title>
</head>
<body>
  Hello World!
</body>
</html>
WELCOME_CONTENTS
    ]]
  end
  run welcome
end
