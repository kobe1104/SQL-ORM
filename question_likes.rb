require 'sqlite3'
require 'singleton'
require_relative "user"
class QuestionLike

  def self.likers_for_question_id(question_id)
    users = QuestionsDatabase.instance.execute(<<-SQL, question_id: question_id)
    SELECT
      *
    FROM
      users
    JOIN
      question_likes
    ON
      users.id = author_id
    WHERE
      question_id = :question_id
    SQL
    return nil if users.empty?
    users.map { |user| User.new(user) }
  end

  def self.liked_questions_for_user_id(author_id)
    questions = QuestionsDatabase.instance.execute(<<-SQL, author_id: author_id)
    SELECT
      *
    FROM
      questions
    JOIN
      question_likes
    ON
      questions.id = question_likes.question_id
    WHERE
      author_id = :author_id
    SQL
    return nil if questions.empty?
    questions.map { |question| Question.new(question) }
  end

  def self.num_likes_for_question_id(question_id)
    num_likes = QuestionsDatabase.instance.execute(<<-SQL, question_id: question_id)
    SELECT
      COUNT(*)
    FROM
      question_likes
    Where
      question_id = :question_id
    SQL
    num_likes.pop.values.last
  end

  def most_liked_questions(n)
    most_liked = QuestionsDatabase.instance.execute(<<-SQL, n: n)
      SELECT
        question_id
      FROM
        question_likes
      ORDER BY
        COUNT(*) DESC
      LIMIT
        :n
    SQL
    return nil if most_liked.empty?
    most_liked.map {|question| Question.new(question)}
  end


  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @author_id = options['author_id']
  end
end
