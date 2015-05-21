class Question < ActiveRecord::Base
  belongs_to :user
  has_many :answers

  validates :title, presence: true
  validates :user, presence: true

  def owner?(user)
    self.user == user
  end
end
