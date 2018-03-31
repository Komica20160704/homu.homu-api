# encoding: utf-8
require './lib/homu_getter'
require './lib/homu_block_parser'

class HomuApi
  def self.get_page page_number
    homu_getter = HomuGetter.new
    homu_getter.download_page page_number
    do_parse homu_getter
  rescue Exception => e
    puts "GetPage faile: #{e.message}"
  end

  def self.get_res res_no
    homu_getter = HomuGetter.new
    homu_getter.download_res res_no
    res = do_parse homu_getter
    res.first
  rescue Exception => e
    puts "GetPage faile: #{e.message}"
  end

  private

  def self.do_parse homu_getter
    parser = HomuBlockParser.new
    result = homu_getter.blocks.map { |block| parser.parse(block) }
    return result
  end
end
