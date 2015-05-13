class QuestionsController < ApplicationController
  before_action :find_question, only: [:show]

  def index
    @questions = Question.all
  end

  def show
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  private

  def find_question
    @question = Question.find(params[:id])
  end
end
