# frozen_string_literal: true

def json_posts
  headers 'Access-Control-Allow-Origin' => '*'
  posts = yield if block_given?
  json posts.as_json(except: %i[id head_id])
end

get %r{/posts/(?<kid>[\w\.\/]{8})(|.json)} do |kid|
  json_posts { Post.recent.where(kid: kid) }
end

get %r{/posts(|.json)} do
  page = params[:page].try(:to_i) || 1
  json_posts { Post.today.page(page) }
end

get %r{/posts/last(|.json)} do
  json_posts { Post.today.last(10) }
end
