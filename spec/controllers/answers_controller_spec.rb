require 'rails_helper'

describe AnswersController do

  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }

  describe 'POST #create' do

    context 'when user is signed in' do

      before(:each) { sign_in user }

      context 'with valid attributes' do

        before(:each) { post :create, question_id: question.id, answer: attributes_for(:answer) }

        it 'adds answer to question' do
          expect(question.answers.count).to eq(1)
        end

        it 'adds user to answer' do
          expect(question.answers.first.user).to eq(user)
        end

        it { should redirect_to question_path(question) }

      end

      context 'with invalid attributes' do

        before(:each) { post :create, question_id: question.id, answer: { contents: nil } }

        it 'does not answer to question' do
          expect(question.answers.count).to eq(0)
        end

        it { should render_template 'questions/show' }
      end
    end

    context 'when user is NOT signed in' do

      context 'with valdi attributes' do

        before(:each) { post :create, question_id: question.id, answer: attributes_for(:answer) }

        it 'does not answer to question' do
          expect(question.answers.count).to eq(0)
        end

        it { should redirect_to new_user_session_path }

      end
    end
  end

  describe 'POST #upvote' do

    context 'when user is signed in as answer author' do

      before(:each) do
        sign_in answer.user
        post :upvote, question_id: question.id, answer_id: answer.id
      end

      it { should set_flash[:alert].to('Voting on yourself is so lame! You cannot do this.') }
      it { should redirect_to question_path(question) }

      it 'does not upvotes to answer' do
        expect(answer.get_upvotes.size).to eq(0)
      end
    end

    context 'when user is signed in NOT as answer author' do

      context 'when user have already voted' do

        before(:each) do
          sign_in user
          answer.liked_by user
          post :upvote, question_id: question.id, answer_id: answer.id
        end

        it { should set_flash[:alert].to('You have already upvoted this answer') }
        it { should redirect_to question_path(question) }

        it 'does not upvotes to answer' do
          expect(answer.get_upvotes.size).to eq(1)
        end
      end

      context 'when user have not voted yet' do

        before(:each) do
          sign_in user
          post :upvote, question_id: question.id, answer_id: answer.id
        end

        it { should set_flash[:success].to('You upvoted the answer') }
        it { should redirect_to question_path(question) }

        it 'upvotes to answer' do
          expect(answer.get_upvotes.size).to eq(1)
        end
      end
    end

    context 'when user is NOT signed in' do

      before(:each) { post :upvote, question_id: question.id, answer_id: answer.id }

      it 'does not upvotes to answer' do
        expect(answer.get_upvotes.size).to eq(0)
      end

      it { should redirect_to new_user_session_path }
    end

  end

end
