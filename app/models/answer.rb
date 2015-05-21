class Answer < ActiveRecord::Base
  acts_as_votable

  belongs_to :user
  belongs_to :question

  validates :contents, presence: true
end
