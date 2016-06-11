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

ENV['OPENSHIFT_DATA_DIR'] = './temp/' if ENV['OPENSHIFT_DATA_DIR'].nil?

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


begin
  data = File.read(ENV['OPENSHIFT_DATA_DIR'] + 'game_users.txt', :encoding => 'UTF-8')
  data = JSON.parse data
rescue
  data = [ { 'id' => "admin", 'password' => "qwerasdf", 'url' => "qwerasdf" } ]
  File.write ENV['OPENSHIFT_DATA_DIR'] + 'game_users.txt', data.to_json
end
users = data
message_lines = []
configure(:development) { set :session_secret, "take_it_down" }
enable :sessions

get '/game' do
  redirect "/game/#{session[:url]}" if session[:url]
  erb :game
end

get '/game/save' do
  File.write ENV['OPENSHIFT_DATA_DIR'] + 'game_users.txt', users.to_json
  204
end

get '/game/:url' do |url|
  user = users.find do |user|
    user['url'] == url
  end
  if user.nil?
    session['url'] = nil
    redirect "/game"
  end
  session[:url] = url
  ml = message_lines.size > 30 ? message_lines[-30] : message_lines
  erb :board, :locals => { :id => user['id'], :url => url, :message_lines => ml }
end

post '/game/login' do
  user = users.find do |user|
    user['id'] == params['id'] and user['password'] == params['password']
  end
  redirect "/game" if user.nil?
  session[:url] = user['url']
  redirect "/game/#{user['url']}"
end

post '/game/post' do
  user = users.find do |user|
    user['url'] == session[:url]
  end
  return 204 if user.nil?
  time = Time.new.strftime("%Y/%m/%d %H:%M")
  message_line = { :id => user['id'], :message => params['message'], :time_stamp => time }
  message_lines << message_line if params['message'] != ''
  redirect "/game/#{user['url']}"
end

post '/verify' do
  begin
    HomuAPI.Verify params
    user = users.find do |u|
      u['id'] == params['id']
    end
    if user.nil?
      url = (0...50).map { ('a'..'z').to_a[rand(26)] }.join
      users << { 'id' => params['id'], 'password' => params['password'], 'url' => url }
    else
      url = user['url']
      user['password'] = params['password']
    end
    redirect "/game/#{url}"
  rescue Exception => e
    '驗證失敗: ' + e.message
  end
end

post '/test' do
  params.to_json
end
