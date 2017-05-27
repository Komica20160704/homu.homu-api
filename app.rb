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
  headers 'Access-Control-Allow-Origin': '*'
  begin
    return JSON.pretty_generate(HomuAPI.GetPage(page))
  rescue OpenURI::HTTPError
    status 404
    return { :success => 0, :message => "找不到此頁" }.to_json
  end
end

get '/res/:no' do |no|
  headers 'Access-Control-Allow-Origin': '*'
  begin
    res = HomuAPI.GetRes(no, :archive => params['archive'])
    return JSON.pretty_generate(res)
  rescue PageNotFoundException
    status 404
    return { :success => 0, :message => "找不到此討論串" }.to_json
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

get '/api' do
  erb :api
end

# require './game.rb'

post '/test' do
  params.to_json
end
