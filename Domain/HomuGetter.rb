# encoding: utf-8
require 'open-uri'
require 'timeout'
require 'nokogiri'

class HomuGetter
  attr_writer :isGetfromArchive
  attr_writer :board

  def initialize
    @page_url = 'https://rem.komica2.net/'
    @archive_url = 'https://archive.komica.org/'
    @res_url = '/pixmicat.php?res='
    @board = '00'
    @isGetfromArchive = false
  end

  def DownloadPage page
    page = 'index' if page == '0'
    host = @isGetfromArchive ? @archive_url : @page_url
    url = host + @board + '/pixmicat.php?page_num=' + page.to_i.to_s
    puts 'DownloadPage: ' + url
    Timeout.timeout 3 do
      @html = Nokogiri::HTML(open(url).read)
    end
  end

  def DownloadRes no
    url = @isGetfromArchive ? @archive_url : @page_url
    res_url = url + @board + @res_url + no.to_s
    puts 'DownloadRes: ' + res_url
    Timeout.timeout 3 do
      @html = Nokogiri::HTML(open(res_url).read)
    end
  end

  def CutHtml
    @html.search('br').each do |n| n.replace("\n") end
    @html.search('font').each do |n| n = n.text if n['color'] == '789922' end
    @blocks = @html.css('.thread')
  end

  def Blocks
    return @blocks
  end

  def Contents
    return @contents
  end

  private

  def make_blocks
    children = []
    @main_form.children.each do |c|
      children << c
    end
    @blocks = []
    @blocks << make_block(children) until children.size == 0
    @blocks.pop unless @isGetfromArchive
  end

  def make_block children
    block_node = Nokogiri::XML::Node.new 'block', @main_form
    block = []
    while children.size > 0
      c = children.delete_at 0
      break if c.node_name == 'sprate'
      c.parent = block_node
    end
    Nokogiri::HTML block_node.to_s
  end

  def save_contents
    @contents = []
    head_index = 0
    @blocks.each do |block|
      body = []
      body_index = 0
      block.xpath("//html//body//blockquote").each do |content|
        body << process_content(content.content)
        content.content = "{ \"Head\":#{head_index}, \"Body\":#{body_index} }"
        body_index += 1
      end
      @contents << body
      head_index += 1
    end
  end

  def process_content content
    return content.lstrip
  end
end
