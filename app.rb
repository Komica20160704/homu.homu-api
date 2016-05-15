# encoding: utf-8
require 'sinatra'
require 'json'
require './Domain/HomuAPI'

get '/' do
  homu = HomuAPI.new
  return JSON.pretty_generate(homu.GetPage('index'))
end

get '/page/:page' do |page|
  homu = HomuAPI.new
  return JSON.pretty_generate(homu.GetPage(page))
end

get '/res/:no' do |no|
  homu = HomuAPI.new
  return JSON.pretty_generate(homu.GetRes(no))
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
