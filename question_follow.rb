require 'sqlite3'
require 'singleton'
require_relative 'question'

class QuestionFollow
    attr_reader :id, :author_id, :question_id

    def self.most_followed_questions(n)
      most_followed = QuestionsDatabase.instance.execute(<<-SQL, n: n)
        SELECT
          question_id
        FROM
          question_follows
        ORDER BY
          COUNT(*) DESC
        LIMIT
          :n
      SQL
      return nil if most_followed.empty?
      most_followed.map {|question| Question.new(question)}
    end

    def self.find_by_id(id)

    end

    def self.followers_for_question_id(question_id)
      followers = QuestionsDatabase.instance.execute(<<-SQL, question_id: question_id)
      SELECT
        *
      FROM
        users
      JOIN
        question_follows
      ON
        users.id = author_id
      WHERE
        question_follows.question_id = :question_id
      SQL
      return nil if followers.empty?
      followers.map { |follower| User.new(follower) }
    end

    def self.follow_questions_for_user_id(author_id)
      questions = QuestionsDatabase.instance.execute(<<-SQL, author_id: author_id)
      SELECT
        *
      FROM
        questions
      JOIN
        question_follows
      ON
        -- questions.id = question_follows.question_id
        questions.id = question_id
      WHERE
        question_follows.author_id = :author_id
      SQL
      return nil if questions.empty?
      questions.map { |question| Question.new(question) }
    end

    def initialize(options)
      @id = options['id']
      @author_id = options['author_id']
      @question_id = options['question_id']
    end



end
