require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do

  let(:question) { create(:question) }

  describe 'GET #index' do
    it 'returns http success and renders the :index template' do
      get :index
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:index)
    end

    it 'assigns all questions as @questions' do
      get :index
      expect(assigns(:questions)).to eq([question])
    end
  end

  describe 'GET #show' do
    it 'returns http success and renders the :show template' do
      get :show, { id: question }
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)
    end

    it 'assigns the requested question as @question' do
      get :show, { id: question }
      expect(assigns(:question)).to eq(question)
    end
  end
end
