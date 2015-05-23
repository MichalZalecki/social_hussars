class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.question_answered.subject
  #
  def question_answered(answer)
    @greeting = "Hi"

    mail to: answer.question.user.email
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.answer_accepted.subject
  #
  def answer_accepted(answer)
    @greeting = "Hi"

    mail to: answer.user.email
  end
end
