# encoding: utf-8
require 'open-uri'
require 'timeout'
require 'nokogiri'
require './lib/hosts/temporary_homu'

class HomuGetter
  attr_reader :blocks, :contents

  def initialize archive: nil, timeout: nil
    @host_url = 'https://ram.komica2.net/'
    @archive_url = 'https://archive.komica.org/'
    @page_url = '/pixmicat.php?page_num='
    @res_url = '/pixmicat.php?res='
    @board = '00'
    @from_archive = !archive.nil?
    @timeout = timeout || 3

    @host = Hosts::TemporaryHomu.new
  end

  def download_page page
    page = 'index' if page.to_s == '0'
    # url = "#{host}#{@board}#{@page_url}#{page}"
    url = @host.page(page)
    puts "DownloadPage: #{url}"
    get_html url
  end

  def download_res no
    # url = "#{host}#{@board}#{@res_url}#{no.to_i}"
    url = @host.res(no)
    puts "DownloadRes: #{url}"
    get_html url
  end

  def host
    @from_archive ? @archive_url : @host_url
  end

  private

  def get_html url
    Timeout.timeout(@timeout) do
      raw = open(url).read
      @html = Nokogiri::HTML(raw)
      @html.encoding = 'utf-8'
    end
    @html.search('br').each { |n| n.replace("\n") }
    @html.search('font').each { |n| n = n.text if n['color'] == '789922' }
    @blocks = @html.css('.thread')
  end
end
