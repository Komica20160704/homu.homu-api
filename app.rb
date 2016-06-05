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
    return JSON.pretty_generate(HomuAPI.GetRes(no))
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

get '/:board/' do |board|
  @page = params['page']
  @board = board
  @page = '0' if @page.nil?
  erb :ptt_index
end

require './Domain/ChatRoom/ChatRoom'
set :server, :thin
connections = []
@@chatRoom = ChatRoom::ChatRoom.new

get '/chat' do
  user = @@chatRoom.NewUser
  redirect "/chat/#{user.Id}"
end

get '/chat/subject/:userId', :provides => 'text/event-stream' do |userId|
  puts "-------------------------------------"
  puts "connections.size: #{connections.size}"
  stream :keep_open do |out|
    puts "out.object_id: #{out.object_id}"
    connections << out
    # @@chatRoom.Welcome userId, out
  end
  puts "connections.size: #{connections.size}"
  puts "-------------------------------------"
end

get '/chat/:userId' do |userId|
  @userId = userId
  user = @@chatRoom.FindUser(userId)
  redirect '/chat' if user.nil?
  erb :chat_room
end

post '/chat/send' do
  userId = params[:userId]
  message = params[:message]
  sender = @@chatRoom.FindUser(userId)
  puts "/////////////////////////////////////"
  connections.each do |out|
    puts "out.object_id: #{out.object_id}"
    out << "data: #{sender.Name}: #{message}\n\n"
  end
  puts "/////////////////////////////////////"
  # @@chatRoom.SendMessage(userId, message)
  204 # response without entity body
end

