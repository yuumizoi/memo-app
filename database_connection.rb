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
    raise 'Database connection is not established. Call DatabaseConnection.connect first.' unless @connection

    @connection.exec_params(sql, params)
  end
end
