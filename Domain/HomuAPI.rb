require './Domain/HomuGetter'
require './Domain/HomuBlockParser'

class HomuAPI
  def GetPage page_number
    page = []
    homuGetter = HomuGetter.new
    homuGetter.DownloadPage page_number
    homuGetter.CutHtml
    parser = HomuBlockParser.new homuGetter.Contents
    blocks = homuGetter.Blocks
    blocks.each do |block|
      page << parser.Parse(block)
    end
    return page
  end

  def GetRes res_no
    res = []
    homuGetter = HomuGetter.new
    homuGetter.DownloadRes res_no
    homuGetter.CutHtml
    parser = HomuBlockParser.new homuGetter.Contents
    blocks = homuGetter.Blocks
    blocks.each do |block|
      res << parser.Parse(block)
    end
    return res.first
  end
end