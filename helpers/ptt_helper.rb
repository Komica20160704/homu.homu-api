# frozen_string_literal: true

module PttHelper
  def get_push_count(count)
    i = count.to_i
    return '    ' if count.nil?
    return "<span class=\"f2 hl\">   #{count}</span>" if i < 10
    return "<span class=\"f3 hl\">  #{count}</span>" if i >= 10 && i < 100
    return '<span class="f1 hl">  爆</span>' if i >= 100
  end

  def get_date(date)
    date[-5..-1].to_s.rjust(5).sub(/^0/, ' ')
  end

  def get_n_bytes_string(length, string)
    space = length
    str = ''
    string.each_char do |c|
      space -= count_size(c)
      break if space.negative?
      str += c
    end
    str
  end

  def count_size(string)
    string.each_char.sum do |c|
      c.bytesize > 1 ? 2 : c.bytesize
    end
  end

  def split_n_bytes_string(length, string)
    strs = []
    str = ''
    string.each_char do |c|
      if count_size(str) + count_size(c) > length
        strs.push str
        str = ''
      end
      str += c
    end
    strs.push(str)
  end

  def get_title(dialog)
    tag = dialog['Title']
    content = dialog['Content'].strip.split("\n").first
    tag = get_n_bytes_string 4, tag
    content = get_n_bytes_string 48, content
    "<a href='read/#{dialog['No']}'>[#{tag}] #{content}</a>"
  end

  def get_long_line(dialog)
    number = dialog['No'][1..7].rjust(7)
    push_count = get_push_count dialog['HiddenBodyCount']
    date = get_date dialog['Date']
    id = dialog['Id']
    title = get_title dialog
    "#{number}#{push_count}#{date} #{id} #{title}"
  end

  def origin_picture(picture)
    "#{Hosts::Const::HOMU_IMAGE}/src/#{picture}"
  end

  def small_picture(picture)
    "#{Hosts::Const::HOMU_IMAGE}/thumb/#{File.basename(picture, '.*')}s.jpg"
  end

  def source_url(number)
    "#{Hosts::Const::HOMU_INDEX}pixmicat.php?res=#{number}"
  end

  def body_line(line)
    line.chomp!
    if line.start_with? '>'
      return "</span><span class=\"f7 push-content\">#{line}"
    end
    line
  end

  def build_line(body, line, first)
    color = first ? nil : 'f0 '
    datetime = "#{body['Date'][5..9]} #{body['Time'][0..4]}"
    "<span class=\"#{color}hl push-tag\">No.#{body['No']} </span>" \
    "<span class=\"f3 hl push-userid\">#{body['Id']}</span>" \
    "<span class=\"f3 push-content\">: #{body_line line}</span>" \
    "<span class=\"push-ipdatetime\">#{datetime}</span>"
  end

  def write_body(body)
    first_line = true
    text = ''
    body['Content'].each_line do |lines|
      next if lines == "\n"
      split_n_bytes_string(66, lines).each do |line|
        text += "<div class='push'>#{build_line(body, line, first_line)}</div>"
        first_line = false if first_line
      end
    end
    text
  end
end
