require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do

  describe 'GET #index' do
    let(:question) { create(:question) }

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
    let(:question) { create(:question) }

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
    let(:question) { create(:question) }

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

  describe 'POST #create' do
    context 'when user signed in' do
      let(:user) { create(:user) }
      before(:each) { sign_in user }

      context 'with valid attributes' do
        it 'creates the new question' do
          expect {
            post :create, question: attributes_for(:question)
          }.to change(Question, :count).by(1)
        end

        it 'redirects to the :show action for the new question' do
          post :create, question: attributes_for(:question)
          expect(response).to redirect_to question_path(Question.first)
        end
      end

      context 'with invalid attributes' do
        it 'does not create the new question' do
          expect {
            post :create, question: attributes_for(:question, title: nil)
          }.to change(Question, :count).by(0)
        end

        it 're-renders the :new method' do
          post :create, question: attributes_for(:question, title: nil)
          expect(response).to render_template(:new)
        end
      end
    end

    context 'when user NOT signed in' do
      it 'redirects to the sign in path' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
