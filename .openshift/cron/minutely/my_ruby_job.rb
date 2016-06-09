#! /usr/bin/ruby -w
puts ENV['$OPENSHIFT_RUBY_LOG_DIR']
puts File.methods
File.write ENV['$OPENSHIFT_RUBY_LOG_DIR'], 'a min'
