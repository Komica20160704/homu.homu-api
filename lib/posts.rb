# frozen_string_literal: true

def json_posts
  headers 'Access-Control-Allow-Origin' => '*'
  posts = yield if block_given?
  json posts.as_json(type: :homu)
end

get '/posts' do
  page = params[:page].try(:to_i) || 1
  query = params.slice :id, :number, :head_number, :title, :name
  id = query.delete :id
  query[:kid] = id if id.present?
  posts = Post.reorder(number: :desc).page(page)
  posts = posts.where(query) if query.present?
  json_posts { posts }
end
