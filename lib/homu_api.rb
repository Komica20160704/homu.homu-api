# frozen_string_literal: true

require './lib/homu_getter'
require './lib/homu_block_parser'

class HomuApi
  def self.get_page(page_number)
    homu_getter = HomuGetter.new
    homu_getter.download_page page_number
    do_parse homu_getter
  rescue StandardError => e
    puts "GetPage faile: #{e.inspect}"
  end

  def self.get_res(res_no)
    homu_getter = HomuGetter.new
    homu_getter.download_res res_no
    res = do_parse homu_getter
    res.first
  rescue StandardError => e
    puts "GetPage faile: #{e.inspect}"
  end

  private_class_method

  def self.do_parse(homu_getter)
    parser = HomuBlockParser.new
    homu_getter.blocks.map { |block| parser.parse(block) }
  end
end
