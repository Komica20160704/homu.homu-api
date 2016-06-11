#! /usr/bin/ruby -w
puts "pre_stop_.rb"
require 'open-uri'
begin
  open('http://' + ENV['OPENSHIFT_GEAR_DNS'] + '/game/save')
rescue Exception => e
  puts e.message
end
puts "pre_stop_.rb end"
