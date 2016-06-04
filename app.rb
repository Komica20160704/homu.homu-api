# encoding: utf-8
require 'sinatra'
require 'json'
require './Domain/HomuAPI'

get '/' do
  @page = params['page']
  @page = '0' if @page.nil?
  erb :ptt_index
end

get '/page/:page' do |page|
  return JSON.pretty_generate(HomuAPI.GetPage(page))
end

get '/res/:no' do |no|
  return JSON.pretty_generate(HomuAPI.GetRes(no))
end

get '/read/:no' do |no|
  @ref_no = no
  begin
    erb :ptt
  rescue PageNotFoundException
    "找不到此討論串"
  rescue Exception => e
    result = e.message + "<br>"
    result += e.backtrace.join("<br>")
    return result
  end
end

get '/read_comic/:no' do |no|
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
