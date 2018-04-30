# encoding: utf-8
require 'json'
require './lib/detail'

class HomuBlockParser
  DATE_FORMAT = /(?<date>((\d{4}|\d{2})(\/\d{2}){2}))/
  WEEK_DAY_FORMAT = /\((?<weekday>[一二三四五六日]{1})\)/
  TIME_FORMAT = /(?<time>\d{2}(:\d{2}){1,2}(\.\d{2,3}|))/
  DATETIME_FORMAT = /#{DATE_FORMAT}\s*#{WEEK_DAY_FORMAT}\s*#{TIME_FORMAT}/
  ID_FORMAT = /ID:(?<id>.{8})/
  DETAIL_FORMAT = /#{DATETIME_FORMAT}\s*#{ID_FORMAT}/
  NUMBER_FORMAT = /No\.(?<no>\d+)/
  HIDEN_BODY_FORMAT = /有回應\s(?<counts>\d+)\s篇被省略。(要閱讀所有回應請按下回應連結。|)/

  def parse block
    details = block.css('div.post').map { |dialog| do_match dialog }
    head = details.shift
    bodies = details
    save_result_to_posts head, bodies
    block_hash = {
      'Head' => head.to_hash,
      'Bodies' => bodies.map(&:to_hash),
    }
    return block_hash
  end

  private

  def save_result_to_posts head, bodies
    head_post = head.find_or_create_post
    numbers = bodies.map &:no
    post_numbers = Post.where(number: numbers).pluck(:number)
    bodies.each do |body|
      next if post_numbers.include?(body.no)
      body.create_post(head_post)
    end
  end

  def do_match dialog
    detail = match_detail dialog
    detail.picture = match_picture dialog
    detail.content = match_content dialog
    detail.hiden_body_count = match_hiden_body dialog
    return detail
  end

  def match_detail dialog
    datas = ['nil']
    matched = dialog.css('span.now').text.match DETAIL_FORMAT
    number_matched = dialog.css('span.qlink').text.match NUMBER_FORMAT
    datas.push dialog.css('span.title').text.strip
    datas.push dialog.css('span.name').text.strip
    datas.push matched[:date]
    datas.push matched[:time]
    datas.push matched[:id]
    datas.push number_matched[:no]
    return Detail.new datas
  end

  def match_picture dialog
    picture = dialog.css('div.file-text a').text.strip
    return picture if picture != ''
  end

  def match_content dialog
    content = dialog.css('div.quote').text.strip
    return content if content != ''
  end

  def match_hiden_body dialog
    matched = dialog.css('span.warn_txt2').text.match(HIDEN_BODY_FORMAT)
    return matched[:counts] if matched
  end
end
