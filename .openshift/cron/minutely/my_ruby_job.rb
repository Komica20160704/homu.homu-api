#! /usr/bin/ruby -w
ENV.keys.each do |key|
  puts "#{key}: #{ENV[key]}"
end

require 'open-uri'
open('http://' + ENV['OPENSHIFT_GEAR_DNS'] + '/onlywatch/record')
