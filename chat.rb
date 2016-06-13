require 'sinatra'
require 'sinatra/async'
require 'eventmachine'
require './Domain/ChatRoom/ChatRoom'

begin
  gem 'passenger', '=5.0.28'
  require 'passenger'
rescue Exception => e
  puts e.message
end

class EventSource
  include EventMachine::Deferrable

  def send(data, id = nil)
    data.each_line do |line|
      line = "data: #{line.strip}\n"
      @body_callback.call line
    end
    @body_callback.call "id: #{id}\n" if id
    @body_callback.call "\n"
  end

  def each(&blk)
    @body_callback = blk
  end
end

subscribers = []

get '/subscribe' do
  content_type request.preferred_type("text/event-stream", "text/plain")
  body EventSource.new
  subscribers << body
  EM.next_tick { env['async.callback'].call response.finish }
  throw :async
end

post '/msg_subscribe' do
  subscribers.each do |subscriber|
    subscriber.send params[:message]
  end
  204
end

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
