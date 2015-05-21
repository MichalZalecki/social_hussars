require 'rails_helper'

describe AnswersController do

  let(:other_user) { create(:user, :other_user) }
  let(:question) { create(:question) }
  let(:answer_with_author) { create(:answer, :with_author) }

  describe 'POST #create' do

    context 'when user is signed in' do

      before(:each) { sign_in other_user }

      context 'with valid attributes' do

        before(:each) { post :create, question_id: question.id, answer: attributes_for(:answer) }

        it 'adds answer to question' do
          expect(question.answers.count).to eq(1)
        end

        it 'adds user to answer' do
          expect(question.answers.first.user).to eq(other_user)
        end

        it { should redirect_to question_path(question) }

      end

      context 'with invalid attributes' do

        before(:each) { post :create, question_id: question.id, answer: { contents: nil } }

        it 'does not add answer to question' do
          expect(question.answers.count).to eq(0)
        end

        it { should render_template 'questions/show' }
      end
    end

    context 'when user is NOT signed in' do

      context 'with valdi attributes' do

        before(:each) { post :create, question_id: question.id, answer: attributes_for(:answer) }

        it 'does not add answer to question' do
          expect(question.answers.count).to eq(0)
        end

        it { should redirect_to new_user_session_path }

      end
    end
  end

  describe 'POST #upvote' do

    before(:each) { post :upvote, question_id: question.id, answer_id: answer_with_author.id }

    context 'when user is signed in as answer author' do
    end

    context 'when user is signed in NOT as answer author' do
      context 'when user have already voted' do
      end

      context 'when user have not voted yet' do
      end
    end

    context 'when user is NOT signed in' do

      it 'does not add upvotes to answer' do
        expect(answer_with_author.get_upvotes.size).to eq(0)
      end

      it { should redirect_to new_user_session_path }
    end

  end

end
