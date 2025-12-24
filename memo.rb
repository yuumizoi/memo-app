# frozen_string_literal: true

require_relative 'database_connection'
DatabaseConnection.connect('memo_app_db')

class Memo
  attr_reader :id, :title, :content

  def initialize(params)
    @id = params['id'].to_i
    @title = params['title']
    @content = params['content']
  end

  def self.all
    sql = <<~SQL
      SELECT id, title, content
      FROM memos
      ORDER BY created_at DESC;
    SQL
    result = DatabaseConnection.query(sql)

    result.map { |row| Memo.new(row) }
  end

  def self.find(id)
    sql = <<~SQL
      SELECT id, title, content FROM memos WHERE id = $1;
    SQL
    result = DatabaseConnection.query(sql, [id.to_i])

    return nil if result.ntuples.zero?

    row = result.first
    Memo.new(row)
  end

  def self.create(title:, content:)
    sql = <<~SQL
      INSERT INTO memos (title, content) VALUES ($1, $2) RETURNING id;
    SQL
    result = DatabaseConnection.query(sql, [title, content])
    id = result.first['id']
    find(id)
  end

  def self.update(id:, title:, content:)
    sql = <<~SQL
      UPDATE memos SET title = $1, content = $2 WHERE id = $3;
    SQL
    DatabaseConnection.query(sql, [title, content, id])
  end

  def self.delete(id)
    sql = <<~SQL
      DELETE FROM memos WHERE id = $1;
    SQL
    DatabaseConnection.query(sql, [id])
  end
end
