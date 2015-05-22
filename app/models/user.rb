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

  def points_for_upvote
    self.points += 5
    self.save
  end

  def points_for_downvote
    self.points -= 5
    self.save
  end

  def points_for_accepted_answer
    self.points += 25
    self.save
  end

  private

  def starting_points
    self.points ||= 100
  end
end
