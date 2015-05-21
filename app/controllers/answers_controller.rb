class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_answer, only: [:upvote, :downvote]
  before_action :find_question, only: [:upvote, :downvote]

  def create
    @answer = Answer.new(answer_params)
    @answer.question_id = params[:question_id]
    @answer.user = current_user
    if @answer.save
      redirect_to question_path(params[:question_id]), notice: 'Answer was created'
    else
      find_question
      render 'questions/show'
    end
  end

  def upvote
    @answer.liked_by current_user
    redirect_to @question
  end

  def downvote
    @answer.downvote_from current_user
    redirect_to @question
  end

  private

  def answer_params
    params.require(:answer).permit(:contents)
  end

  def find_answer
    @answer = Answer.find(params[:answer_id])
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

end
