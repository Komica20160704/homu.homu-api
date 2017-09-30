
class PageNotFoundException < Exception
  def initialize message = 'Page not found!'
    super message
  end
end
