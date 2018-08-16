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
    hashes = homu_getter.blocks.map { |block| parser.parse(block) }
    save_result_to_posts(hashes)
    hashes
  end

  def self.save_result_to_posts(hashes)
    numbers = hashes.map do |hash|
      [hash['Head']['No'], hash['Bodies'].map { |body| body['No'] }]
    end.flatten
    posts = Post.where(number: numbers)
    post_index = posts.index_by(&:number)
    return if (numbers - post_index.keys).blank?
    Post.transaction { save_each_posts(hashes, post_index) }
  end

  def self.save_each_posts(hashes, post_index)
    hashes.map do |hash|
      head = Detail.from_hash(hash['Head'])
      head_post = post_index[head.no].presence || head.create_post
      hash['Bodies'].each { |body| save_bodies(head_post, body, post_index) }
    end
  end

  def self.save_bodies(head_post, body, post_index)
    body = Detail.from_hash(body)
    return if post_index[body.no].present?
    body.create_post(head_post)
  end
end
