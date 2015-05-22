class Answer < ActiveRecord::Base
  acts_as_votable

  belongs_to :user
  belongs_to :question

  validates :contents, presence: true

  def accept
    self.accepted = true
    self.user.points_for_accepted_answer
    self.save
  end
end
