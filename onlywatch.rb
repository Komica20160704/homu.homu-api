require './Domain/OnlyWatch/HeroGetter'
require './Domain/OnlyWatch/HeroRecorder'

get '/onlywatch' do
  getter = OnlyWatch::HeroGetter.new
  getter.DownloadHeroDatas.to_json
end

get '/onlywatch/record' do
  getter = OnlyWatch::HeroGetter.new
  recorder = OnlyWatch::HeroRecorder.new
  data = getter.DownloadHeroDatas.to_json
  recorder.Record data
  204
end

get '/onlywatch/report' do
  recorder = OnlyWatch::HeroRecorder.new
  report = recorder.Report.to_json
  erb :onlywatch, :locals => { :report => report }
end
