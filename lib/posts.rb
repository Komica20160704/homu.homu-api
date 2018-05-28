# frozen_string_literal: true

def json_posts
  headers 'Access-Control-Allow-Origin' => '*'
  posts = yield if block_given?
  json posts.as_json(type: :homu)
end

get '/posts' do
  page = params[:page].try(:to_i) || 1
  id = params[:id].try(:to_s)
  posts = Post.reorder(number: :desc).page(page)
  posts = posts.where(kid: id) if id.present?
  json_posts { posts }
end
