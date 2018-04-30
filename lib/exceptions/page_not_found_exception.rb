# frozen_string_literal: true

class PageNotFoundException < RuntimeError
  def initialize(message = 'Page not found!')
    super message
  end
end
