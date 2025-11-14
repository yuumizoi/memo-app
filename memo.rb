# frozen_string_literal: true
require 'sinatra'
require 'sinatra/contrib'
require 'json'
require 'securerandom'

def load_memos
  File.open('memos.json') do |file|
    JSON.parse(file.read)
  end
end

def save_memos(memos)
  File.open('memos.json', 'w') do |file|
    file.write(JSON.pretty_generate(memos))
  end
end

get '/memos' do
  @memos = load_memos
  erb :index
end

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end

get '/memos/new' do
  erb :new
end

get '/memos/:id' do
  memos = load_memos
  @memo = memos.find { |m| m['id'] == params['id'] }
  erb :show
end

get '/memos/:id/edit' do
  memos = load_memos
  @memo = memos.find { |m| m['id'] == params['id'] }
  erb :edit
end

patch '/memos/:id' do
  memos = load_memos
  memo_to_update = memos.find { |m| m['id'] == params['id'] }
  memo_to_update['title'] = params['title']
  memo_to_update['content'] = params['content']
  save_memos(memos)
  redirect "/memos/#{params['id']}"
end

delete '/memos/:id' do
  memos = load_memos
  memos.delete_if { |m| m['id'] == params['id'] }
  save_memos(memos)
  redirect '/memos'
end

not_found do
  erb :not_found
end

post '/memos' do
  title = params['title']
  content = params['content']
  memos = load_memos
  new_id = SecureRandom.uuid

  new_memo = {
    'id' => new_id,
    'title' => title,
    'content' => content
  }
  memos << new_memo
  save_memos(memos)
  redirect "/memos/#{new_id}"
end
