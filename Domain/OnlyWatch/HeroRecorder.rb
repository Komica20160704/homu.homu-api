# encoding: utf-8
module OnlyWatch
  require 'fileutils'

  class HeroRecorder
    def Record data
      time = Time.new.strftime("%Y-%m-%d")
      path = ENV['OPENSHIFT_DATA_DIR'] + 'onlywatch/' + time + '.dat'
      write_file path, data
    end

    private

    def write_file path, data
      dirname = File.dirname(path)
      unless File.directory?(dirname)
        FileUtils.mkdir_p(dirname)
      end
      File.write path, data
    end
  end
end
