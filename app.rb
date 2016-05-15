require 'sinatra'

require './Domain/HomuGetter'
require './Domain/HomuBlockParser'

get '/:page' do |page|
  page = 'index' if page == '0'
  homu = '[ '
  homuGetter = HomuGetter.new
  homuGetter.DownloadHtml page
  homuGetter.CutHtml
  parser = HomuBlockParser.new homuGetter.Contents
  blocks = homuGetter.Blocks
  blocks.each do |block|
    homu += parser.Parse block
    if block == blocks.last
      homu += ' ]'
    else
      homu += ', '
    end
  end

  return homu
end