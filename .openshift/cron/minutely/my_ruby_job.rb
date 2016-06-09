#! /usr/bin/ruby -w
ENV.keys.each do |key|
  puts "#{key}: #{ENV[key]}"
end

require 'open-uri'
# open(@url)
