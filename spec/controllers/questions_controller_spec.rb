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

  describe 'GET #new' do
    context 'when user is signed in' do
      let(:user) { create(:user) }
      before(:each) { sign_in user }

      it 'returns http success and renders the :new template' do
        get :new
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:new)
      end

      it 'assigns a new question as @question' do
        get :new
        expect(assigns(:question)).to be_a_new(Question)
      end
    end

    context 'when user is NOT signed in' do
      it 'redirects to the sign in path' do
        get :new
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'GET #edit' do
    context 'when user is signed in as the question author' do
      before(:each) { sign_in question.user }

      it 'returns http success and renders the :edit template' do
        get :edit, { id: question }
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:edit)
      end

      it 'assigns the requested question as @question' do
        get :edit, { id: question }
        expect(assigns(:question)).to eq(question)
      end
    end

    context 'when user is signed in NOT as the question author' do
      let(:user) { create(:user) }
      before(:each) { sign_in user }

      it 'redirects to the root path' do
        get :edit, { id: question }
        expect(response).to redirect_to root_path
      end
    end

    context 'when user is NOT signed in' do
      it 'redirects to the sign in path' do
        get :edit, { id: question }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
