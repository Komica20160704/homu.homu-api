  require './Domain/HomuGetter'
  require './Domain/HomuBlockParser'

  @homu = '[ '
  homuGetter = HomuGetter.new
  homuGetter.DownloadHtml 0
  homuGetter.CutHtml
  parser = HomuBlockParser.new homuGetter.Contents
  blocks = homuGetter.Blocks
  blocks.each do |block|
    @homu += parser.Parse block
    if block == blocks.last
      @homu += ' ]'
    else
      @homu += ', '
    end
  end
