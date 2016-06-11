#! /usr/bin/ruby -w
require 'open-uri'
open('http://' + ENV['OPENSHIFT_GEAR_DNS'] + '/game/save')
