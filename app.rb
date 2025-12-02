# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/contrib'
require_relative 'memo'
require_relative 'database_connection'

class Application < Sinatra::Base
  DatabaseConnection.connect('memo_app_db')

  set :erb, escape_html: true
  set :views, File.expand_path('../views', __FILE__)
  set :public_folder, File.expand_path('../public', __FILE__)
  set :layout, :layout
  enable :erb

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
    memo = Memo.find(params['id'])
    if memo
      memo.update(params['title'], params['content'])
      redirect "/memos/#{params['id']}"
    else
      pass
    end
  end

  delete '/memos/:id' do
    memo = Memo.find(params['id'])
    memo.delete if memo
    redirect '/memos'
  end

  not_found do
    erb :not_found
  end

  post '/memos' do
    new_memo = Memo.create(title: params['title'], content: params['content'])
    redirect "/memos/#{new_memo.id}"
  end
end
