class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_question, only: [:show, :edit]
  before_action :question_owner!, only: [:edit]

  def index
    @questions = Question.all
  end

  def show
  end

  def new
    @question = Question.new
  end

  def create
  end

  def edit
  end

  def update
  end

  private

  def question_owner!
    redirect_to root_path unless current_user == @question.user
  end

  def find_question
    @question = Question.find(params[:id])
  end
end
