class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_question, only: [:show, :edit, :update]
  before_action :authenticate_owner!, except: [:index, :show, :new, :create]

  def index
    @questions = Question.all
  end

  def show
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)
    if @question.save
      redirect_to @question, success: 'Question was created'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @question.update(question_params)
      redirect_to @question, success: 'Question was updated'
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
end
