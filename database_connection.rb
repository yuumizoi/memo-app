# frozen_string_literal: true

require 'pg'

class DatabaseConnection
  @connection = nil

  def self.connect(database_name)
    return @connection if @connection

    @connection = PG.connect(dbname: database_name)
    @connection
  end

  def self.query(sql, params = [])
    connect('memo_app_db').exec_params(sql, params)
  end
end
