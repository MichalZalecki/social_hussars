class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_answer, only: [:upvote, :downvote, :accept]
  before_action :find_question
  before_action :check_accepted!, only: [:create]

  def create
    @answer = Answer.new(answer_params)
    @answer.question_id = params[:question_id]
    @answer.user = current_user
    if @answer.save
      UserMailer.question_answered(@answer).deliver_later
      redirect_to question_path(params[:question_id]), notice: I18n.t('controllers.answers.created')
    else
      render 'questions/show'
    end
  end

  def upvote
    if current_user == @answer.user
      @message = { type: :alert, content: I18n.t('controllers.answers.voting_on_yourself') }
    elsif current_user.voted_up_on? @answer
      @message = { type: :alert, content: I18n.t('controllers.answers.already_upvoted') }
    else
      @message = { type: :success, content: I18n.t('controllers.answers.upvoted') }
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
      @message = { type: :alert, content: I18n.t('controllers.answers.voting_on_yourself') }
    elsif current_user.voted_down_on? @answer
      @message = { type: :alert, content: I18n.t('controllers.answers.already_downvoted') }
    else
      @message = { type: :success, content: I18n.t('controllers.answers.downvoted') }
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
        flash[:alert] = I18n.t('controllers.answers.already_accepted')
        throw(:done)
      elsif current_user != @question.user
        flash[:alert] = I18n.t('controllers.answers.only_author')
        throw :done
      elsif current_user == @answer.user
        flash[:alert] = I18n.t('controllers.answers.accept_your')
        throw :done
      else
        flash[:success] = I18n.t('controllers.answers.accepted')
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

  def check_accepted!
    if @question.accepted?
      redirect_to @question, alert: I18n.t('controllers.answers.already_accepted')
    end
  end
end
