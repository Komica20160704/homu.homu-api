require 'uri'
require 'net/http'
POSTBODY = '{"7898173":"delete","mode":"usrdel","pwd":"qwer"}'
class HomuPoster
  def PostNew params
    uri = URI("http://homu.komica.org/00/index.php")
    https = Net::HTTP.new(uri.host, uri.port)
    puts https.post(uri.path, get_post_body(params)).body
  end

  def PostDeletion no, pwd
    uri = URI("http://homu.komica.org/00/index.php")
    https = Net::HTTP.new(uri.host, uri.port)
    post_body = get_post_body({ no => "delete", "mode" => "usrdel", "pwd" => pwd })
    puts post_body
    puts 'HomuPoster:16'
    # https.post(uri.path, get_post_body(params)).body
  end

  private

  def get_post_body params
    post_body = ""
    params.each_key do |key|
      post_body += key + '=' + params[key] + '&'
    end
    post_body
  end
end

HomuPoster.new.PostDeletion "123", "456"
