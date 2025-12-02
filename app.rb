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
end
