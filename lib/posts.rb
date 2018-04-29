def get_posts_json
  headers 'Access-Control-Allow-Origin' => '*'
  posts = yield if block_given?
  json posts.as_json(except: :id)
end

get %r{/posts/(?<kid>[\w\.\/]{8})(|.json)} do |kid|
  get_posts_json { Post.this_week.where(kid: kid) }
end

get %r{/posts(|.json)} do
  page = params[:page].try(:to_i) || 1
  get_posts_json { Post.today.page(page) }
end

get %r{/posts/last(|.json)} do
  get_posts_json { Post.today.last(10) }
end
