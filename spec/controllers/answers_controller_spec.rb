require 'rails_helper'

describe AnswersController do

  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:question_with_answers) { create(:question, :with_answers) }
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

      it 'does not upvotes answer' do
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

        it 'does not upvotes answer' do
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

        it 'upvotes answer' do
          expect(answer.get_upvotes.size).to eq(1)
        end
      end
    end

    context 'when user is NOT signed in' do

      before(:each) { post :upvote, question_id: question.id, answer_id: answer.id }

      it 'does not upvotes answer' do
        expect(answer.get_upvotes.size).to eq(0)
      end

      it { should redirect_to new_user_session_path }
    end

  end

  describe 'POST #downvote' do

    context 'when user is signed in as answer author' do

      before(:each) do
        sign_in answer.user
        post :downvote, question_id: question.id, answer_id: answer.id
      end

      it { should set_flash[:alert].to('Voting on yourself is so lame! You cannot do this.') }
      it { should redirect_to question_path(question) }

      it 'does not downvotes answer' do
        expect(answer.get_downvotes.size).to eq(0)
      end
    end

    context 'when user is signed in NOT as answer author' do

      context 'when user have already voted' do

        before(:each) do
          sign_in user
          answer.downvote_from user
          post :downvote, question_id: question.id, answer_id: answer.id
        end

        it { should set_flash[:alert].to('You have already downvoted this answer') }
        it { should redirect_to question_path(question) }

        it 'does not downvotes answer' do
          expect(answer.get_downvotes.size).to eq(1)
        end
      end

      context 'when user have not voted yet' do

        before(:each) do
          sign_in user
          post :downvote, question_id: question.id, answer_id: answer.id
        end

        it { should set_flash[:success].to('You downvoted the answer') }
        it { should redirect_to question_path(question) }

        it 'downvotes answer' do
          expect(answer.get_downvotes.size).to eq(1)
        end
      end
    end

    context 'when user is NOT signed in' do

      before(:each) { post :downvote, question_id: question.id, answer_id: answer.id }

      it 'does not upvotes answer' do
        expect(answer.get_upvotes.size).to eq(0)
      end

      it { should redirect_to new_user_session_path }
    end
  end

  describe 'POST #accpet' do

    context 'when user is signed in as question author' do

      before(:each) { sign_in question_with_answers.user }

      context 'when question is already accepted' do

        let(:question_answer) { question_with_answers.answers.first }
        before(:each) do
          question_answer.accepted = true
          question_answer.save
          post :accept, question_id: question_with_answers.id, answer_id: question_answer.id
        end

        it { should set_flash[:alert].to('This question is already accepted') }
        it { should redirect_to question_path(question_with_answers) }
      end

      context 'when question is NOT accepted yet' do

        let(:question_answer) { question_with_answers.answers.first }
        before(:each) do
          post :accept, question_id: question_with_answers.id, answer_id: question_answer.id
        end

        it { should set_flash[:success].to('You have accepted the answer') }
        it { should redirect_to question_path(question_with_answers) }

        it 'accepts the answer' do
          expect(question_with_answers.accepted?).to be(true)
        end
      end
    end

    context 'when user is signed in NOT as question author' do

      let(:question_answer) { question_with_answers.answers.first }
      let(:other_user) { create(:user) }
      before(:each) do
        sign_in other_user
        post :accept, question_id: question_with_answers.id, answer_id: question_answer.id
      end

      it { should set_flash[:alert].to('Only the question author can accept the question') }
      it { should redirect_to question_path(question_with_answers) }

      it 'does not accepts the answer' do
          expect(question_with_answers.accepted?).to be(false)
      end
    end

    context 'when user is signed in as answer author' do

      let(:question_answer) { question_with_answers.answers.first }
      before(:each) do
        # this situation shouldn't happen but it won't brake if any
        question_with_answers.user = question_answer.user
        question_with_answers.save
        sign_in question_answer.user
        post :accept, question_id: question_with_answers.id, answer_id: question_answer.id
      end

      it { should set_flash[:alert].to('Accepting yours answer is so lame! You cannot do this.') }
      it { should redirect_to question_path(question_with_answers) }

      it 'does not accepts the answer' do
          expect(question_with_answers.accepted?).to be(false)
      end
    end

    context 'when user is NOT signed in' do

      let(:question_answer) { question_with_answers.answers.first }
      before(:each) do
        post :accept, question_id: question_with_answers.id, answer_id: question_answer.id
      end

      it { should redirect_to new_user_session_path }

    end
  end
end
