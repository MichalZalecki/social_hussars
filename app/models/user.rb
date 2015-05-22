class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  acts_as_voter

  has_many :questions
  has_many :answers

  before_validation :points_for_start

  POINTS_FOR_VOTE            = 5
  POINTS_FOR_ASKING_QUESTION = 10
  POINTS_FOR_ACCEPTED_ANSWER = 25
  POINTS_FOR_START           = 100

  def to_s
    "#{email} (#{points})"
  end

  def points_for_upvote(user, answer)
    if user.voted_down_on? answer
      self.points += POINTS_FOR_VOTE * 2
    else
      self.points += POINTS_FOR_VOTE
    end
    self.save
  end

  def points_for_downvote(user, answer)
    if user.voted_up_on? answer
      self.points -= POINTS_FOR_VOTE * 2
    else
      self.points -= POINTS_FOR_VOTE
    end
    self.save
  end

  def points_for_accepted_answer
    self.points += POINTS_FOR_ACCEPTED_ANSWER
    self.save
  end

  def points_for_asking_question
    self.points -= POINTS_FOR_ASKING_QUESTION
    self.save
  end

  def able_to_ask_question?
    self.points >= POINTS_FOR_ASKING_QUESTION
  end

  private

  def points_for_start
    self.points ||= POINTS_FOR_START
  end
end
