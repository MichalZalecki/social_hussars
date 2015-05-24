class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_answer, only: [:upvote, :downvote, :accept]
  before_action :find_question

  def create
    @answer = Answer.new(answer_params)
    @answer.question_id = params[:question_id]
    @answer.user = current_user
    if @answer.save
      UserMailer.question_answered(@answer).deliver_later
      redirect_to question_path(params[:question_id]), notice: 'Answer was created'
    else
      render 'questions/show'
    end
  end

  def upvote
    if current_user == @answer.user
      @message = { type: :alert, content: 'Voting on yourself is so lame! You cannot do this.' }
    elsif current_user.voted_up_on? @answer
      @message = { type: :alert, content: 'You have already upvoted this answer' }
    else
      @message = { type: :success, content: 'You upvoted the answer' }
      @answer.user.points_for_upvote(current_user, @answer)
      @answer.liked_by current_user
    end
    respond_to do |format|
      format.html do
        flash[@message[:type]] = @message[:content]
        redirect_to @question
      end
      format.json { render :vote }
    end
  end

  def downvote
    if current_user == @answer.user
      @message = { type: :alert, content: 'Voting on yourself is so lame! You cannot do this.' }
    elsif current_user.voted_down_on? @answer
      @message = { type: :alert, content: 'You have already downvoted this answer' }
    else
      @message = { type: :success, content: 'You downvoted the answer' }
      @answer.user.points_for_downvote(current_user, @answer)
      @answer.downvote_from current_user
    end
    respond_to do |format|
      format.html do
        flash[@message[:type]] = @message[:content]
        redirect_to @question
      end
      format.json { render :vote }
    end
  end

  def accept
    catch(:done) do
      if @question.accepted?
        flash[:alert] = 'This question is already accepted'
        throw(:done)
      elsif current_user != @question.user
        flash[:alert] = 'Only the question author can accept the question'
        throw :done
      elsif current_user == @answer.user
        flash[:alert] = 'Accepting yours answer is so lame! You cannot do this.'
        throw :done
      else
        flash[:success] = 'You have accepted the answer'
        @answer.accept
        UserMailer.answer_accepted(@answer).deliver_later
        throw :done
      end
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
