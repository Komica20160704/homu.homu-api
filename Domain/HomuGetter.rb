# encoding: utf-8
require 'open-uri'
require 'nokogiri'
require './Domain/Exception/PageNotFoundException'

class HomuGetter
  attr_writer :isGetfromArchive
  attr_writer :board

  def initialize
    @page_url = 'http://rem.komica.org/'
    @archive_url = 'http://archive.komica.org/'
    @res_url = '/pixmicat.php?res='
    @board = '00'
    @isGetfromArchive = false
  end

  def DownloadPage page
    page = 'index' if page == '0'
    url = @isGetfromArchive ? @archive_url : @page_url
    puts 'DownloadPage: ' + url + @board + '/' + page.to_s + '.htm'
    @html = Nokogiri::HTML(open(url + @board + '/' + page.to_s + '.htm').read)
  end

  def DownloadRes no
    url = @isGetfromArchive ? @archive_url : @page_url
    puts 'DownloadRes: ' + url + @board + @res_url + no.to_s
    @html = Nokogiri::HTML(open(url + @board + @res_url + no.to_s).read)
  end

  def CutHtml
    @html.search('br').each do |n| n.replace("\n") end
    # @html.search('hr').each do |n| n.replace('<sprate>sprate</sprate>') end
    @html.search('font').each do |n| n = n.text if n['color'] == '789922' end
    # @main_form = @isGetfromArchive ? @html.xpath("//html//body//div")[1] : @html.xpath("//html//form")[1]
    # zones = @html.to_s.split '<sprate>sprate</sprate>'
    # zones = zones[3..-2]
    # @blocks = []
    # zones.each do |z|
    #   if z.match /(\d\d\/\d\d\/\d\d)\(.\)(\d\d:\d\d)\sID:(.{0,})/
    #     @blocks << Nokogiri::HTML(z)
    #   end
    # end
    @blocks = @html.css('.thread')
    # @main_form = @html
    # raise PageNotFoundException if @main_form.nil?
    # make_blocks
    # save_contents
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
    block_node = Nokogiri::XML::Node.new "block", @main_form
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
