# encoding: utf-8
require 'sinatra'
require 'sinatra/reloader' if development?
require 'json'
require 'open-uri'
require './Domain/HomuAPI'

set :show_exceptions, false if settings.environment == 'production'

get '/' do
  @page = params['page']
  @page = '0' if @page.nil?
  erb :ptt_index
end

get '/page/:page' do |page|
  headers 'Access-Control-Allow-Origin' => '*'
  content_type :json
  begin
    return HomuAPI.GetPage(page).to_json
  rescue OpenURI::HTTPError
    status 404
    return { success: 0, message: '找不到此討論串' }.to_json
  end
end

get '/res/:no' do |no|
  headers 'Access-Control-Allow-Origin' => '*'
  content_type :json
  begin
    return HomuAPI.GetRes(no, archive: params['archive']).to_json
  rescue OpenURI::HTTPError
    status 404
    return { success: 0, message: '找不到此討論串' }.to_json
  end
end

get '/read/:no' do |no|
  @ref_no = no
  begin
    erb :ptt
  rescue OpenURI::HTTPError
    redirect '/'
  end
end

get '/comic/:no' do |no|
  @ref_no = no
  begin
    erb :comic
  rescue OpenURI::HTTPError
    '找不到此討論串'
  end
end

get '/api' do
  erb :api
end

post '/test' do
  params.to_json
end
