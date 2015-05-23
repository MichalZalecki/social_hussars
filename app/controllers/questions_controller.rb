class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_question, only: [:show, :edit, :update]
  before_action :authenticate_owner!, except: [:index, :show, :new, :create]
  before_action :check_points!, except: [:index, :show, :edit, :update]

  def index
    @questions = Question.order('created_at DESC')
  end

  def show
    @answer = Answer.new
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_user
    if @question.save
      redirect_to @question, flash: { success: 'Question was created' }
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @question.update(question_params)
      redirect_to @question, flash: { success: 'Question updated' }
    else
      render :edit
    end
  end

  private

  def authenticate_owner!
    redirect_to root_path unless current_user == @question.user
  end

  def find_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :contents)
  end

  def check_points!
    unless current_user.able_to_ask_question?
      redirect_to root_path, alert: 'You don\'t have enougth points to ask the question'
    end
  end
end
