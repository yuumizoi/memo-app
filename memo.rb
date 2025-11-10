# frozen_string_literal: true

require 'sinatra'
require 'sinatra/contrib'
# require 'sinatra/reloader'
require 'json'
require 'securerandom'

# --- メソッドの定義 ---
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

# --- ルーティング (URI設計) ---
# GET /memos (メモ一覧)
get '/memos' do
  @memos = load_memos
  erb :index
end

# --- ヘルパーメソッドの定義 ---
# Sinatra::Contrib の require が効かない環境向けに、hメソッドを明示的に定義
helpers do
  include Rack::Utils
  alias_method :h, :escape_html

# GET /memos/new（メモ作成画面）
get '/memos/new' do
  erb :new
end

# GET /memos/:id（特定のメモを表示）
get '/memos/:id' do
  memos = load_memos
  @memo = memos.find { |m| m['id'] == params['id'] }
  erb :show
end

# GET /memos/:id/edit (メモ編集画面)
get '/memos/:id/edit' do
  memos = load_memos
  @memo = memos.find { |m| m['id'] == params['id'] }
  erb :edit
end

# PATCH /memos/:id (メモ編集・上書き保存)
patch '/memos/:id' do
  memos = load_memos
  memo_to_update = memos.find { |m| m['id'] == params['id'] }
  memo_to_update['title'] = params['title']
  memo_to_update['content'] = params['content']
  save_memos(memos)
  redirect "/memos/#{params['id']}"
end

# DELETE /memos/:id（メモ削除）
delete '/memos/:id' do
  memos = load_memos
  memos.delete_if { |m| m['id'] == params['id'] }
  save_memos(memos)
  redirect '/memos'
end

# 404 Not Found処理
not_found do
  erb :not_found
end

# POST /memos（メモ作成）
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
