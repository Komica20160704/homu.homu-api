# frozen_string_literal: true

require 'net/http'
require 'timeout'
require 'nokogiri'
require './lib/hosts/homu'

class HomuGetter
  attr_reader :blocks, :contents

  def initialize
    @timeout = 3
    @host = Hosts::Homu.new
  end

  def download_page(page)
    url = @host.page page
    puts "DownloadPage: #{url}"
    get_html url
  end

  def download_res(res_no)
    url = @host.res res_no
    puts "DownloadRes: #{url}"
    get_html url
  end

  def host
    @host_url
  end

  private

  def get_html(url)
    Timeout.timeout @timeout do
      raw = Net::HTTP.get URI url
      @html = Nokogiri::HTML raw
    end
    @html.encoding = 'utf-8'
    @html.search('br').each { |n| n.replace("\n") }
    @blocks = @html.css('.thread')
  end
end
