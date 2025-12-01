# frozen_string_literal: true

require 'sinatra'
require 'sinatra/contrib'
require 'json'
require 'securerandom'

MEMO_FILE = 'memos.json'

def load_memos
  save_memos({}) unless File.exist?(MEMO_FILE)
  file_content = File.read(MEMO_FILE)
  JSON.parse(file_content)
end

def save_memos(memos)
  File.open(MEMO_FILE, 'w') do |file|
    file.write(JSON.pretty_generate(memos))
  end
end

def get_memo(id)
  load_memos[id]
end

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end

get '/memos' do
  @memos = load_memos.values
  erb :index
end

get '/memos/new' do
  erb :new
end

get '/memos/:id' do
  @memo = get_memo(params['id'])
  pass if @memo.nil?
  erb :show
end

get '/memos/:id/edit' do
  @memo = get_memo(params['id'])
  pass if @memo.nil?
  erb :edit
end

patch '/memos/:id' do
  memos = load_memos
  memo = memos[params['id']]
  if memo
    memo['title'] = params['title']
    memo['content'] = params['content']
    save_memos(memos)
    redirect "/memos/#{params['id']}"
  else
    pass
  end
end

delete '/memos/:id' do
  memos = load_memos
  memos.delete(params['id'])
  save_memos(memos)
  redirect '/memos'
end

not_found do
  erb :not_found
end

post '/memos' do
  memos = load_memos
  new_id = SecureRandom.uuid

  memos[new_id] = {
    'id' => new_id,
    'title' => params['title'],
    'content' => params['content']
  }

  save_memos(memos)
  redirect "/memos/#{new_id}"
end
