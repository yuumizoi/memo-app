# frozen_string_literal: true

# database_connection.rb
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
  rescue PG::Error => e
    puts "Database Error: #{e.message}"
    raise e
  end
end
