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
    return JSON.pretty_generate(HomuAPI.new.GetPage(page))
  rescue OpenURI::HTTPError
    status 404
    return { :message => "找不到此頁" }.to_json
  end
end

get '/res/:no' do |no|
  begin
    return JSON.pretty_generate(HomuAPI.new.GetRes(no))
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

get '/post_wait' do
  erb :post_wait
end

get '/poster' do
  @no = params['no']
  erb :poster
end

require './Domain/ChatRoom/ChatRoom'

@@chatRoom = ChatRoom::ChatRoom.new
get '/chat' do
  user = @@chatRoom.NewUser
  redirect "/chat/#{user.Id}"
end

get '/chat/:userId' do |userId|
  @userId = userId
  erb :chat_room
end

post '/chat/send' do
  userId = params[:userId]
  message = params[:message]
  @@chatRoom.SendMessage(userId, message)
end

post '/chat/receive' do
  userId = params[:userId]
  @@chatRoom.ReceiveMessage(userId).to_json
end
