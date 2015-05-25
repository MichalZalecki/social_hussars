class UserMailer < ApplicationMailer
  default from: 'no-reply@social-hussars.herokuapp.com'

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.question_answered.subject
  #
  def question_answered(answer)
    @answer = answer
    mail to: answer.question.user.email
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.answer_accepted.subject
  #
  def answer_accepted(answer)
    @answer = answer
    mail to: answer.user.email
  end
end
