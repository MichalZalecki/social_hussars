class Question < ActiveRecord::Base
  belongs_to :user
  has_many :answers

  validates :title, presence: true
  validates :user, presence: true

  after_create :points_for_asking_question

  def owner?(user)
    self.user == user
  end

  def accepted?
    self.answers.pluck(:accepted).reduce(:|)
  end

  private

  def points_for_asking_question
    self.user.points_for_asking_question
  end
end
