require './Domain/HomuGetter'
require './Domain/HomuPoster'
require './Domain/HomuBlockParser'

class HomuAPI
  def GetPage page_number
    homuGetter = HomuGetter.new
    homuGetter.DownloadPage page_number
    page = do_parse homuGetter
    return page
  end

  def GetRes res_no
    homuGetter = HomuGetter.new
    homuGetter.DownloadRes res_no
    res = do_parse homuGetter
    return res.first
  end

  def PostNew params
    poster = HomuPoster.new
    poster.PostNew params
  end

  private

  def do_parse homuGetter
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