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
    if current_user == @answer.user
      flash[:alert] = 'Voting on yourself is so lame! You cannot do this.'
    elsif current_user.voted_up_on? @answer
      flash[:alert] = 'You have already upvoted this answer'
    else
      flash[:success] = 'You upvoted the answer'
      @answer.user.points_for_upvote
      @answer.liked_by current_user
    end
    redirect_to @question
  end

  def downvote
    if current_user == @answer.user
      flash[:alert] = 'Voting on yourself is so lame! You cannot do this.'
    elsif current_user.voted_down_on? @answer
      flash[:alert] = 'You have already downvoted this answer'
    else
      flash[:success] = 'Your downvoted the answer'
      @answer.user.points_for_downvote
      @answer.downvote_from current_user
    end
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
