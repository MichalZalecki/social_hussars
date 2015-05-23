class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/question_answered
  def question_answered
    UserMailer.question_answered
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/answer_accepted
  def answer_accepted
    UserMailer.answer_accepted
  end

end
