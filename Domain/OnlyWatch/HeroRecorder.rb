# encoding: utf-8
module OnlyWatch
  require 'fileutils'
  require 'json'

  class HeroRecorder
    def initialize
      if ENV['OPENSHIFT_DATA_DIR'].nil?
        @data_dir = './temp/onlywatch/'
      else
        @data_dir = ENV['OPENSHIFT_DATA_DIR'] + 'onlywatch/'
      end
      unless File.directory?(@data_dir)
        FileUtils.mkdir_p(@data_dir)
      end
    end

    def Record data
      time = Time.new.strftime("%Y-%m-%d")
      path = @data_dir + time + '.dat'
      File.write path, data
    end

    def Report
      report = Hash.new
      read_files report
      return report
    end

    private

    def read_files report
      Dir.foreach(@data_dir) do |item|
        next if item == '.' or item == '..'
        data = File.read(@data_dir + item, :encoding => 'UTF-8')
        data = JSON.parse(data)
        add_data data, report
      end
    end

    def add_data data, report
      data.each do |hero|
        report[hero['name']] = [] if report[hero['name']].nil?
        report[hero['name']] << hero['winrate']
      end
    end
  end
end
