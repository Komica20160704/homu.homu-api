require './lib/hosts/const'

module Hosts
  class TemporaryHomu
    def initialize
      @host_url = 'https://rem.komica.org/00test/'
      @page_url = '.htm?'
      @res_url = '/pixmicat.php?res='
    end

    # https://rem.komica.org/00test/index.htm?
    def page page
      "#{@host_url}#{page}#{@page_url}"
    end

    # https://rem.komica.org/00test/pixmicat.php?res=847563
    def res no
      "#{@host_url}#{@res_url}#{no}"
    end
  end
end
