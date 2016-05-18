require 'uri'
require 'net/http'

class HomuPoster
  def PostNew params
    uri = URI("http://homu.komica.org/00/index.php")
    https = Net::HTTP.new(uri.host, uri.port)
    puts https.post(uri.path, get_post_body(params)).body
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