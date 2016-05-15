require 'sinatra'
require './Domain/HomuAPI'

get '/' do
  homu = HomuAPI.new
  homu.GetPage 'index'
end

get '/page/:page' do |page|
  homu = HomuAPI.new
  homu.GetPage page
end

get '/res/:no' do |no|
  homu = HomuAPI.new
  homu.GetRes no
end