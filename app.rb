# frozen_string_literal: true

require 'sinatra/base'
require_relative 'memo'
require_relative 'database_connection'

class Application < Sinatra::Base
  set :views, File.expand_path('views', __dir__)
  set :public_folder, File.expand_path('public', __dir__)
  set :layout, :layout

  helpers do
    include Rack::Utils
    alias_method :h, :escape_html
  end

  get '/memos' do
    @memos = Memo.all
    erb :index
  end

  get '/memos/new' do
    erb :new
  end

  get '/memos/:id' do
    @memo = Memo.find(params['id'])
    pass if @memo.nil?
    erb :show
  end

  get '/memos/:id/edit' do
    @memo = Memo.find(params['id'])
    pass if @memo.nil?
    erb :edit
  end

  patch '/memos/:id' do
    Memo.update(
      id: params['id'],
      title: params['title'],
      content: params['content']
    )
    redirect "/memos/#{params['id']}"
  end

  delete '/memos/:id' do
    Memo.delete(params['id'])
    redirect '/memos'
  end

  post '/memos' do
    new_memo = Memo.create(title: params['title'], content: params['content'])
    redirect "/memos/#{new_memo.id}"
  end

  not_found do
    erb :not_found
  end
end
