require 'sqlite3'
require 'singleton'
require_relative 'question'
require_relative 'question_follow'

class QuestionsDatabase < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')
    self.type_translation = true
    self.results_as_hash = true
  end
end

class User
  attr_accessor :id, :fname, :lname
  def self.find_by_id(id)
    ids = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        users
      WHERE
        id = ?
    SQL
    return nil if ids.empty?
    ids.map {|id| User.new(id)}
  end

  def self.find_by_name(fname, lname)
    questions = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
      SELECT
        *
      FROM
        users
      WHERE
        fname = ? AND lname = ?
    SQL
    return nil if questions.length == 0
    questions.map { |user| User.new(user) }
  end

  def authored_questions(author_id)
    questions = Question.find_by_author_id(author_id)
  end

  def authored_replies(author_id)
    replies = Reply.find_by_author_id(author_id)
  end

  def initialize(options)
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end

  def followed_questions
    QuestionFollow.follow_questions_for_user_id(@id)
  end

  def liked_questions
    QuestionLike.liked_questions_for_user_id(@id)
  end

  def average_karma
    ave_like = QuestionsDatabase.instance.execute(<<-SQL, author_id: @id)
    (SELECT AVG(SELECT COUNT(*) FROM question_likes)
    FROM
      questions
    LEFT OUTER JOIN
      question_likes
    ON
      question_likes.question_id = questions.id
    WHERE question_likes.author_id = :author_id


    )



    SQL
  end

  # def save
  #     ids = QuestionsDatabase.instance.execute()
  #   if @id.nil?
  #
  #   end
  # end
end
