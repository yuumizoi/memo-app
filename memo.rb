# frozen_string_literal: true

require_relative 'database_connection'

class Memo
  attr_reader :id, :title, :content

  def initialize(id:, title:, content:)
    @id = id.to_i
    @title = title
    @content = content
  end
end
