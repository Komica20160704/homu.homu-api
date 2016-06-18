ENV['OPENSHIFT_DATA_DIR'] = './temp/' if ENV['OPENSHIFT_DATA_DIR'].nil?

require 'fileutils'
require 'json'

module UndeadWorld
  DATA_DIR = ENV['OPENSHIFT_DATA_DIR'] + 'undead_world/'
  USERS_DIR = DATA_DIR + 'users/'
  DATA_DIRS = [DATA_DIR, USERS_DIR]

  class Application
    def initialize
      setup_data_dir
      load_datas
    end

    def sing_in id, password
      user = { "id" => id, "password" => password }
      dir = Dir.open USERS_DIR
      raise "IdExistedError" if dir.entries.include? "#{id}.data"
      File.write USERS_DIR + "#{id}.data", user.to_json
    end

    private

    def setup_data_dir
      DATA_DIRS.each do |dir|
        FileUtils.mkdir_p(dir) unless File.directory?(dir)
      end
    end

    def load_datas
      # begin
      #   @players = JSON.parse File.read(DATA_DIR + 'game_users.txt', :encoding => 'UTF-8')
      # rescue
      #   @players = [ { 'id' => "admin", 'password' => "qwerasdf", 'url' => "qwerasdf" } ]
      #   File.write DATA_DIR + 'game_users.txt', @players.to_json
      # end
      # begin
      #   @message_lines = JSON.parse mdata File.read(DATA_DIR + 'game_message_lines.txt', :encoding => 'UTF-8')
      # rescue
      #   @message_lines = [ { 'id' => ":::::", 'message' => '測試用聊天室 須手動重新整理', 'time_stamp' => '::::::' } ]
      #   File.write DATA_DIR + 'game_message_lines.txt', @message_lines.to_json
      # end
    end
  end
end
