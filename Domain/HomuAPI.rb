# encoding: utf-8
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
    res = do_parse homuGetter, opts
    return res.first
  end

  def self.Verify params
    begin
      res = HomuAPI.GetRes(params['number'])
    rescue PageNotFoundException
      raise Exception.new("找不到討論串")
    end
    res['Bodies'] << res['Head']
    target = res['Bodies'].find do |block|
      block['No'] == params['no']
    end
    raise Exception.new("找不到文章") if target.nil?
    raise Exception.new("Id錯誤") if target['Id'] != params['id']
    raise Exception.new("密碼不能空白") if params['pwd'] == '' or params['password'] == ''
    homuPoster = HomuPoster.new
    homuPoster.PostDeletion params['no'], params['pwd']
  end

  private

  def self.do_parse homuGetter, opts = {}
    result = []
    homuGetter.CutHtml
    parser = HomuBlockParser.new homuGetter.Contents, !opts[:archive].nil?
    blocks = homuGetter.Blocks
    blocks.each do |block|
      result << parser.Parse(block)
    end
    return result
  end
end
