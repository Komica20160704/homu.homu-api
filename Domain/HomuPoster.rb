# encoding: utf-8
require 'uri'
require 'net/http'

class HomuPoster
  def PostNew params
    uri = URI('https://ram.komica2.net/00/index.php')
    https = Net::HTTP.new(uri.host, uri.port)
    puts https.post(uri.path, get_post_body(params)).body
  end

  def PostDeletion no, pwd
    uri = URI('https://ram.komica2.net/00/index.php')
    https = Net::HTTP.new(uri.host, uri.port)
    post_body = get_post_body({ no: 'delete', mode: 'usrdel', pwd: pwd })
    result = https.post(uri.path, post_body).body
    match = result.match /<font color=red size=5><b>(.{0,})<br><br><a href=index.htm>(.{0,})<\/a><\/b><\/font>/
    raise match[1].force_encoding('UTF-8') if match
  end

  private

  def get_post_body params
    post_body = ''
    params.each_key do |key|
      post_body += key.to_s + '=' + params[key] + '&'
    end
    post_body
  end
end
