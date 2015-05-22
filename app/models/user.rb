class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  acts_as_voter

  has_many :questions
  has_many :answers

  before_validation :starting_points

  def to_s
    "#{email} (#{points})"
  end

  def points_for_upvote(user, answer)
    if user.voted_down_on? answer
      self.points += 10
    else
      self.points += 5
    end
    self.save
  end

  def points_for_downvote(user, answer)
    if user.voted_up_on? answer
      self.points -= 10
    else
      self.points -= 5
    end
    self.save
  end

  def points_for_accepted_answer
    self.points += 25
    self.save
  end

  def points_for_asking_question
    self.points -= 10
    self.save
  end

  def able_to_ask_question?
    self.points >= 10
  end

  private

  def starting_points
    self.points ||= 100
  end
end
