require 'sinatra'
require './Domain/HomuAPI'

get '/'
  homu = HomuAPI.new
  homu.GetPage 0
end

get '/:page' do |page|
  homu = HomuAPI.new
  homu.GetPage page
end

get '/ref/:no' do |no|
  homu = HomuAPI.new
  homu.GetRes no
end