require 'sqlite3'
require 'singleton'
require_relative "user"

class Reply
  attr_accessor :id, :author_id, :parent_id, :question_id, :body

  def self.find_by_id(id)
    replies = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        replies
      WHERE
        id = ?
    SQL
    return nil if replies.empty?
    replies.map {|id| Reply.new(id)}
  end

  def self.find_by_author_id(author_id)
    replies = QuestionsDatabase.instance.execute(<<-SQL, author_id)
    SELECT
      *
    FROM
      replies
    WHERE
      author_id = ?
    SQL
    return nil if replies.empty?
    replies.map { |reply| Reply.new(reply) }
  end

  def self.find_by_question_id(question_id)
    replies = QuestionsDatabase.instance.execute(<<-SQL, question_id)
    SELECT
      *
    FROM
      replies
    WHERE
      question_id = ?
    SQL
    return nil if replies.empty?
    replies.map { |reply| Reply.new(reply) }
  end

  def initialize(options)
    @id = options['id']
    @author_id = options['author_id']
    @parent_id = options['parent_id']
    @question_id = options['question_id']
    @body = options['body']
  end

  def parent_reply
    Reply.find_by_id(@parent_id)
  end

  def child_replies
    all_replies = Reply.find_by_question_id(@question_id)
    all_replies.select {|reply| reply.parent_id == @id}
  end

end
