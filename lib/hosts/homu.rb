# frozen_string_literal: true

require './lib/hosts/const'

module Hosts
  class Homu
    def initialize
      @host_url = Const::HOMU_INDEX
      @page_url = '.htm?'
      @res_url = '/pixmicat.php?res='
    end

    def page(page)
      page = 'index' if page.to_s == '0'
      "#{@host_url}#{page}#{@page_url}"
    end

    def res(res_no)
      "#{@host_url}#{@res_url}#{res_no}"
    end
  end
end
