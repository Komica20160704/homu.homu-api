# frozen_string_literal: true

def headers_posts
  headers 'Access-Control-Allow-Origin' => '*'
  headers 'Access-Control-Allow-Headers' => 'Authorization'
end

def json_posts
  headers_posts
  posts = yield if block_given?
  json posts.as_json(type: :homu)
end

def jwt_posts(token)
  payload, _header = JWT.decode(token, Credential.sabisu_key, true)
  payload['id'] == Credential.sabisu_id &&
    payload['used_value'] <= payload['limit_value']
rescue JWT::DecodeError
  false
end

post '/done' do
  token = params[:token]
  payload, _header = JWT.decode(token, Credential.sabisu_key, true)
  erb :done, locals: { token: token, payload: payload }, layout: nil
end

options('/posts/:number') { headers_posts }
get '/posts/:number' do |number|
  post = Post.find_by(number: number)
  json_posts { post }
end

options('/posts') { headers_posts }
get '/posts' do
  headers_posts
  match = /^Bearer\s(?<token>.+)$/.match(env['HTTP_AUTHORIZATION'])
  token = match.try(:[], :token)
  if token.present?
    is_adv = jwt_posts(token)
    return 401 unless is_adv
  end
  page = params[:page].try(:to_i) || 1
  adv_query = params.slice :number, :head_number, :title, :name
  query = {}
  id = params[:id]
  query[:kid] = id if id.present?
  posts = Post.reorder(number: :desc).where(query).page(page)
  posts = posts.where(adv_query) if is_adv && adv_query.present?
  if query.present?
    headers 'Access-Control-Expose-Headers' => 'Total-Pages'
    headers 'Total-Pages' => posts.total_pages.to_s
  end

  json_posts { posts }
end
