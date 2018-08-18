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
  logger.info "Start #{request.request_method} #{url} for #{request.ip}"
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
  json HomuApi.get_page(page)
end

get '/res/:no' do |no|
  headers 'Access-Control-Allow-Origin' => '*'
  res = HomuApi.get_res(no)
  if res
    json res
  else
    status 404
    json success: false, message: '找不到此討論串'
  end
end

require './lib/posts'

get '/read/:no' do |no|
  res = HomuApi.get_res no
  if res
    @head = res['Head']
    @bodies = res['Bodies']
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
