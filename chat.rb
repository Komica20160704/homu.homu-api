require 'sinatra'
require './Domain/ChatRoom/ChatRoom'

set :server, :thin
@@chatRoom = ChatRoom::ChatRoom.new

get '/chat' do
  user = @@chatRoom.NewUser
  redirect "/chat/#{user.Id}"
end

get '/chat/subject/:userId', :provides => 'text/event-stream' do |userId|
  stream :keep_open do |out|
    @@chatRoom.Welcome userId, out
  end
end

get '/chat/:userId' do |userId|
  @userId = userId
  redirect '/chat' if @@chatRoom.FindUser(userId).nil?
  erb :chat_room
end

post '/chat/send' do
  userId = params[:userId]
  message = params[:message]
  @@chatRoom.SendMessage(userId, message)
  204 # response without entity body
end
