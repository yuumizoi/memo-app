# frozen_string_literal: true

require_relative 'database_connection'

class Memo
  attr_reader :id, :title, :content

  def initialize(id:, title:, content:)
    @id = id.to_i
    @title = title
    @content = content
  end

  def self.all
    sql = "SELECT id, title, content FROM memos ORDER BY created_at DESC;"
    result = DatabaseConnection.query(sql)

    result.map do |row|
      Memo.new(id: row['id'], title: row['title'], content: row['content'])
    end
  end

  def self.find(id)
    sql = "SELECT id, title, content FROM memos WHERE id = $1;"
    result = DatabaseConnection.query(sql, [id.to_i])

    return nil if result.ntuples.zero?

    row = result.first
    Memo.new(id: row['id'], title: row['title'], content: row['content'])
  end

  def self.create(title:, content:)
    sql = "INSERT INTO memos (title, content) VALUES ($1, $2) RETURNING id;"

    result = DatabaseConnection.query(sql, [title, content])

    new_id = result.first['id']
    Memo.new(id: new_id, title: title, content: content)
  end

  def update(title, content)
    sql = "UPDATE memos SET title = $1, content = $2 WHERE id = $3;"

    DatabaseConnection.query(sql, [title, content, @id])

    @title = title
    @content = content
  end

  def delete
    sql = "DELETE FROM memos WHERE id = $1;"

    DatabaseConnection.query(sql, [@id])
  end
end
