# encoding: utf-8
module OnlyWatch
  require 'open-uri'
  require 'nokogiri'
  HERO_ATTRIBUTES = ['name', 'winrate', 'popularity', 'score-min', 'kd-ratio']

  class HeroGetter
    def initialize
      @url = 'http://masteroverwatch.com/heroes'
    end

    def DownloadHeroDatas
      @heros = []
      html = Nokogiri::HTML(open(@url).read)
      hero_html = get_hero_html html
      get_heros hero_html
      return @heros
    end

    def Heros
      return @heros
    end

    private

    def get_hero_html html
      hero_html = html.css('div').select do |node|
        next if node['data-href'].nil?
        node['data-href'].match /^\/heroes\/[\d]+-[\w]+/
      end
      return hero_html
    end

    def get_heros hero_html
      hero_html.each do |h|
        @heros << get_hero_hash(h)
      end
    end

    def get_hero_hash h
      hero = Hash.new
      HERO_ATTRIBUTES.each do |attribute|
        value = h.css("span[data-column='#{attribute}']").text
        hero[attribute] = value
      end
      return hero
    end
  end
end
