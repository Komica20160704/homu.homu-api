require './Domain/HomuGetter'
require './Domain/HomuPoster'
require './Domain/HomuBlockParser'

class HomuAPI
  def self.GetPage page_number, opts = {}
    homuGetter = HomuGetter.new
    homuGetter.isGetfromArchive = opts[:archive] unless opts[:archive].nil?
    homuGetter.board = opts[:board] unless opts[:board].nil?
    homuGetter.DownloadPage page_number
    page = do_parse homuGetter
    return page
  end

  def self.GetRes res_no, opts = {}
    homuGetter = HomuGetter.new
    homuGetter.isGetfromArchive = opts[:archive] unless opts[:archive].nil?
    homuGetter.board = opts[:board] unless opts[:board].nil?
    homuGetter.DownloadRes res_no
    res = do_parse homuGetter
    return res.first
  end

  private

  def self.do_parse homuGetter, opts = {}
    result = []
    homuGetter.CutHtml
    parser = HomuBlockParser.new homuGetter.Contents
    blocks = homuGetter.Blocks
    blocks.each do |block|
      result << parser.Parse(block)
    end
    return result
  end
end