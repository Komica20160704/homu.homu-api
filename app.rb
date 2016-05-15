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
  return (homu.GetRes(no).to_json
end

get '/erb/:no' do |no|
  str = "<%= ERB TEST %>"
  erb str
end