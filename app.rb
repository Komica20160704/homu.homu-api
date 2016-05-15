require 'sinatra'

get '/:page' do |page|
  require './Domain/HomuGetter'
  require './Domain/HomuBlockParser'

  page = 0 if page.nil?

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