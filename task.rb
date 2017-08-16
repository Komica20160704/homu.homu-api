require './app'

pages = 3..99
stop_next_page = false
bads = []

pages.each do |page|
  next if stop_next_page
  reses = HomuAPI.GetPage(page)
  reses.each do |res|
    stop_next_page = true if Date.parse(res['Head']['Date']) != Date.today

    if res['Bodies'].size == 0
      bads << res['Head']
    end

  end
end

File.write('./task.json', bads.to_s)
