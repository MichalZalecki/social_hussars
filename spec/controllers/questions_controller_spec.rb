require 'rails_helper'

describe QuestionsController do

  let(:user) { create(:user) }
  let(:other_user) { create(:user, :other_user) }
  let(:question) { create(:question) }

  it do
    sign_in user
    should permit(:title, :contents).for(:create)
  end

  describe 'GET #index' do

    before(:each) { get :index }

    it { should respond_with(:success) }
    it { should render_template(:index) }

    it 'assigns all questions as @questions' do
      expect(assigns(:questions)).to eq([question])
    end
  end

  describe 'GET #show' do

    before(:each) { get :show, { id: question } }

    it { should respond_with(:success) }
    it { should render_template(:show) }

    it 'assigns the requested question as @question' do
      expect(assigns(:question)).to eq(question)
    end
  end

  describe 'GET #new' do

    context 'when user is signed in' do

      before(:each) do
        sign_in user
        get :new
      end

      it { should respond_with(:success) }
      it { should render_template(:new) }

      it 'assigns a new question as @question' do
        expect(assigns(:question)).to be_a_new(Question)
      end
    end

    context 'when user is NOT signed in' do

      before(:each) { get :new }

      it { should redirect_to new_user_session_path }
    end
  end

  describe 'POST #create' do

    context 'when user signed in' do

      before(:each) { sign_in user }

      context 'with valid attributes' do

        before(:each) { post :create, question: attributes_for(:question) }

        it 'creates the new question' do
          expect(Question.count).to eq(1)
        end


        it { should redirect_to question_path(Question.first) }
      end

      context 'with invalid attributes' do

        before(:each) { post :create, question: attributes_for(:question, title: nil) }

        it 'does not create the new question' do
          expect(Question.count).to eq(0)
        end

        it { should render_template :new }
      end
    end

    context 'when user NOT signed in' do

      before(:each){ post :create, question: attributes_for(:question) }

      it { should redirect_to new_user_session_path }
    end
  end

  describe 'GET #edit' do

    context 'when user is signed in as the question author' do

      before(:each) do
        sign_in question.user
        get :edit, id: question
      end

      it { should respond_with :success }
      it { should render_template :edit }

      it 'assigns the requested question as @question' do
        expect(assigns(:question)).to eq(question)
      end
    end

    context 'when user is signed in NOT as the question author' do

      before(:each) do
        sign_in other_user
        get :edit, id: question
      end

      it { should redirect_to root_path }
    end

    context 'when user is NOT signed in' do

      before(:each) { get :edit, id: question }

      it { should redirect_to new_user_session_path }
    end
  end

  describe 'POST #update' do

    context 'when user is signed in as the question author' do

      before(:each) do
        question
        sign_in question.user
      end

      context 'with valid attributes' do

        before(:each) do
           patch :update, id: question, question: attributes_for(:question, title: 'Updated title' )
        end

        it 'updates the question' do
          expect(Question.first.title).to eq('Updated title')
        end

        it { should redirect_to question_path(question) }
      end

      context 'with invalid attributes' do

        before(:each) do
           patch :update, id: question, question: attributes_for(:question, title: nil )
        end

        it 'does not update the question' do
          expect(Question.first.title).to eq('Question Title')
        end

        it { should render_template :edit }

      end
    end

    context 'when user is signed in NOT as the question author' do

      before(:each) { sign_in other_user }

      context 'with valid attributes' do

        before(:each) do
           patch :update, id: question, question: attributes_for(:question, title: 'Updated title' )
        end

        it 'does not update the question' do
          expect(Question.first.title).to eq('Question Title')
        end

        it { should redirect_to root_path }

      end
    end

    context 'when user is NOT signed in' do

      context 'with valid attributes' do

        before(:each) do
           patch :update, id: question, question: attributes_for(:question, title: 'Updated title' )
        end

        it 'does not update the question' do
          expect(Question.first.title).to eq('Question Title')
        end

        it { should redirect_to new_user_session_path }

      end
    end

  end

end
