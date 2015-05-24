class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:github]

  acts_as_voter

  has_many :questions
  has_many :answers
  has_attached_file :avatar, styles: { thumb: '100x100#' }, default_url: '/images/blank.jpg'

  validates :username, presence: true, uniqueness: true
  validates_attachment_content_type :avatar, content_type: /^image\/(png|gif|jpeg|jpg)/
  validates_attachment_size :avatar, less_than: 1.megabyte

  before_validation :points_for_start

  POINTS_FOR_VOTE            = 5
  POINTS_FOR_ASKING_QUESTION = 10
  POINTS_FOR_ACCEPTED_ANSWER = 25
  POINTS_FOR_START           = 100
  POINTS_TO_BE_A_SUPERSTAR   = 1000

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create! do |user|
      # when user which is already redistered has the same
      # username as github nickname of new user
      github_username = unique_username(auth.info.nickname)

      # it's possible email wont be passed (depends on privacy settings)
      github_email = auth.info.email.nil? ? "#{auth.info.nickname}@users.noreply.github.com" : auth.info.email

      user.username = github_username
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = github_email
      user.password = Devise.friendly_token[0,20]
    end
  end

  def to_s
    "#{username} (#{points})"
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

  def superstar?
    self.points >= POINTS_TO_BE_A_SUPERSTAR
  end

  def self.unique_username(username)
    unique = username
    while User.unscoped.exists?(username: unique) do
      unique = username + '-' + rand(36**8).to_s(36)
    end
    unique
  end

  private

  def points_for_start
    self.points ||= POINTS_FOR_START
  end

end
