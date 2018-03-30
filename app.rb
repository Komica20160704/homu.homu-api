# encoding: utf-8
require 'sinatra'
require 'sinatra/reloader' if development?
require 'json'
require 'open-uri'
require './lib/homu_api'

set :show_exceptions, false if production?
set :default_timeout, development? ? 30 : 3
set :root, File.dirname(__FILE__)

get '/' do
  @page = params['page'].to_i
  pages = []
  threads = (@page..(@page + 1)).map do |page|
    Thread.new { pages << HomuApi.get_page(page, timeout: settings.default_timeout) }
  end
  threads.each &:join
  blocks = pages.flatten.compact.reverse!
  @heads = blocks.map { |block| block['Head'] }
  erb :ptt_index
end

get '/page/:page' do |page|
  headers 'Access-Control-Allow-Origin' => '*'
  content_type :json
  begin
    return HomuApi.get_page(page).to_json
  rescue OpenURI::HTTPError
    status 404
    return { success: 0, message: '找不到此討論串' }.to_json
  end
end

get '/res/:no' do |no|
  headers 'Access-Control-Allow-Origin' => '*'
  content_type :json
  begin
    return HomuApi.get_res(no, archive: params['archive']).to_json
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
