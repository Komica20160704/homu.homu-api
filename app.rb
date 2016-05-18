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
  return JSON.pretty_generate(HomuAPI.new.GetPage(page))
end

get '/res/:no' do |no|
  return JSON.pretty_generate(HomuAPI.new.GetRes(no))
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

get '/post_wait' do
  erb :post_wait
end

get '/post_form' do
  erb :post_form
end

get '/poster' do
  @no = params['no']
  erb :poster
end
