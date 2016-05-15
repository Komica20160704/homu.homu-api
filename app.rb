require 'sinatra'
require './Domain/HomuAPI'

get '/' do
  homu = HomuAPI.new
  return (homu.GetPage('index')).to_json
end

get '/page/:page' do |page|
  homu = HomuAPI.new
  return (homu.GetPage(page)).to_json
end

get '/res/:no' do |no|
  homu = HomuAPI.new
  return (homu.GetRes(no)).to_json
end

get '/read/:no' do |no|
  test_str = 'this is test string'
  begin
    erb :ptt 
  rescue Exception => e
    result = e.message + "<br>"
    result += e.backtrace.join("<br>")
    return result
  end
end