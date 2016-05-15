# encoding: utf-8
require 'open-uri'
require 'nokogiri'

class HomuGetter
  def initialize
    @page_url = 'http://homu.komica.org/00/'
    @res_url = 'http://homu.komica.org/00/index.php?res='
  end

  def DownloadPage page
    page = 'index' if page == '0'
    @html = Nokogiri::HTML(open(@page_url + page.to_s + '.htm').read)
  end

  def DownloadRes no
    @html = Nokogiri::HTML(open(@res_url + no.to_s).read)
  end

  def CutHtml
    @html.search('br').each do |n| n.replace("\n") end
    @html.search('hr').each do |n| n.replace('<sprate>sprate<\sprate>') end
    @html.search('font').each do |n|
      n.replace("#{n.text}") if n['color'] == '789922'
    end
    @main_form = @html.xpath("//html//form")[1]
    make_blocks
    save_contents
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
    @blocks.pop
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
        body << content.content
        content.content = "{ \"Head\":#{head_index}, \"Body\":#{body_index} }"
        body_index += 1
      end
      @contents << body
      head_index += 1
    end
  end
end
