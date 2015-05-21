require 'rails_helper'

describe AnswersController do

  let(:other_user) { create(:user, :other_user) }
  let(:question) { create(:question) }

  describe 'POST #create' do

    context 'when user is signed in' do

      before(:each) { sign_in other_user }

      context 'with valid attributes' do

        before(:each) { post :create, question_id: question.id, answer: attributes_for(:answer) }

        it 'adds answer to question' do
          expect(Answer.count).to eq(1)
        end

        it { should redirect_to question_path(question) }

      end

      context 'with invalid attributes' do

        before(:each) { post :create, question_id: question.id, answer: { contents: nil } }

        it 'does not add answer to question' do
          expect(Answer.count).to eq(0)
        end

        it { should render_template 'questions/show' }
      end
    end

    context 'when user is NOT signed in' do

      context 'with valdi attributes' do

        before(:each) { post :create, question_id: question.id, answer: attributes_for(:answer) }

        it 'does not add answer to question' do
          expect(Answer.count).to eq(0)
        end

        it { should redirect_to new_user_session_path }

      end
    end
  end

end
