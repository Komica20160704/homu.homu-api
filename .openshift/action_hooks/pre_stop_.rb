#! /usr/bin/ruby -w
puts "pre_stop_.rb"
require 'open-uri'
open('http://' + ENV['OPENSHIFT_GEAR_DNS'] + '/game/save')
