class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @answer = Answer.new(answer_params)
    @answer.question_id = params[:question_id]
    if @answer.save
      redirect_to question_path(params[:question_id]), notice: 'Answer was created'
    else
      @question = Question.find(params[:question_id])
      render 'questions/show'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:contents)
  end

end
