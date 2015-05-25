class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/question_answered
  def question_answered
    UserMailer.question_answered Answer.last
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/answer_accepted
  def answer_accepted
    UserMailer.answer_accepted Answer.last
  end

end
