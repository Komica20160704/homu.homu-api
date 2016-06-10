# encoding: utf-8
require 'sinatra'
require 'json'
require 'open-uri'
require './Domain/HomuAPI'

get '/' do
  @page = params['page']
  @page = '0' if @page.nil?
  erb :ptt_index
end

get '/page/:page' do |page|
  begin
    return JSON.pretty_generate(HomuAPI.GetPage(page))
  rescue OpenURI::HTTPError
    status 404
    return { :message => "找不到此頁" }.to_json
  end
end

get '/res/:no' do |no|
  begin
    res = HomuAPI.GetRes(no, :archive => params['archive'])
    puts res
    return JSON.pretty_generate(res)
  rescue PageNotFoundException
    status 404
    return { :message => "找不到此討論串" }.to_json
  end
end

get '/read/:no' do |no|
  @ref_no = no
  begin
    erb :ptt
  rescue PageNotFoundException
    redirect '/'
  end
end

get '/comic/:no' do |no|
  @ref_no = no
  begin
    erb :comic
  rescue PageNotFoundException
    "找不到此討論串"
  rescue Exception => e
    result = e.message + "<br>"
    result += e.backtrace.join("<br>")
    return result
  end
end

# get '/:board/' do |board|
#   @page = params['page']
#   @board = board
#   @page = '0' if @page.nil?
#   erb :ptt_index
# end

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
  recorder.Report.to_json
end

get '/game' do
  erb :game
end

post '/test' do
  params.to_json
end
