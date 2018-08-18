# frozen_string_literal: true

require 'sinatra'
require 'sinatra/contrib'
require 'sinatra/reloader' if development?
require 'json'
require 'open-uri'
require './lib/homu_api'
require './helpers/ptt_helper'

set :logger, Thin::Logging.logger
set :show_exceptions, false if production?
set :root, File.dirname(__FILE__)

helpers PttHelper

before do
  logger.info "Start #{request.request_method} #{url}"
  logger.info "Params: #{params}"
end

after { logger.info "Complete #{status}" }

get '/' do
  @page = params['page'].to_i
  pages = []
  threads = (@page..(@page + 1)).map do |page|
    Thread.new { pages << HomuApi.get_page(page) }
  end
  threads.each(&:join)
  blocks = pages.flatten.compact
  @heads = blocks.map { |block| block['Head'] }
  @heads.sort_by! { |head| head['No'] }
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
    return HomuApi.get_res(no).to_json
  rescue OpenURI::HTTPError
    status 404
    return { success: 0, message: '找不到此討論串' }.to_json
  end
end

require './lib/posts'

get '/read/:no' do |no|
  res = HomuApi.get_res no
  @head = res['Head']
  @bodies = res['Bodies']
  if res
    erb :ptt
  else
    redirect '/'
  end
end

get '/comic/:no' do |no|
  @res = HomuApi.get_res no
  if @res
    erb :comic
  else
    redirect '/'
  end
end

get '/api' do
  erb :api
end

post '/test' do
  params.to_json
end
