require 'rails_helper'

RSpec.describe User, type: :model do

  subject(:user){ build(:user) }
  let(:answer) { create(:answer) }
  let(:voter) { create(:user) }
  let(:other_user) { create(:user) }

  it { should validate_presence_of(:username) }
  it { should have_attached_file(:avatar) }
  it { should validate_attachment_content_type(:avatar)
        .allowing('image/png', 'image/gif', 'image/jpeg', 'image/jpg')
        .rejecting('text/plain', 'text/xml') }
  # this is sloooooowwww
  # it { should validate_attachment_size(:avatar)
  #       .less_than(1.megabyte) }

  it 'has a valid factory' do
    is_expected.to be_valid
  end

  describe 'associations' do
    it { should have_many(:questions) }
    it { should have_many(:answers) }
  end

  describe '#to_s' do

    it 'returns an email and points' do
      expect(user.to_s).to eq("#{user.username} (#{user.points})")
    end
  end

  describe '#points_for_upvote' do

    context 'voter did NOT downvote answer before' do
      it 'gives points for upvote' do
        expect { user.points_for_upvote(voter, answer) }
          .to change(user, :points).by(User::POINTS_FOR_VOTE)
      end
    end

    context 'voter downvoted answer before' do

      before(:each) { answer.downvote_from voter }

      it 'gives points for upvote' do
        expect { user.points_for_upvote(voter, answer) }
          .to change(user, :points).by(User::POINTS_FOR_VOTE*2)
      end
    end
  end

  describe '#points_for_downvote' do

    context 'voter did NOT upvote answer before' do
      it 'takes points for upvote' do
        expect { user.points_for_downvote(voter, answer) }
          .to change(user, :points).by(-User::POINTS_FOR_VOTE)
      end
    end

    context 'voter upvoteed answer before' do

      before(:each) { answer.liked_by voter }

      it 'takes points for upvote' do
        expect { user.points_for_downvote(voter, answer) }
          .to change(user, :points).by(-User::POINTS_FOR_VOTE*2)
      end
    end
  end

  describe '#points_for_accepted_answer' do

    it 'takes points for downvote' do
      expect { user.points_for_accepted_answer }
        .to change(user, :points).by(User::POINTS_FOR_ACCEPTED_ANSWER)
    end
  end

  describe '#points_for_asking_question' do

    it 'takes points for asking question' do
      expect { user.points_for_asking_question }
        .to change(user, :points).by(-User::POINTS_FOR_ASKING_QUESTION)
    end
  end

  describe '#able_to_ask_question' do

    context 'when user has enought points' do

      before(:each) { user.points = User::POINTS_FOR_ASKING_QUESTION }

      it 'returns true' do
        expect(user.able_to_ask_question?).to be(true)
      end
    end

    context 'when user hasn\'t enought points' do

      before(:each) { user.points = User::POINTS_FOR_ASKING_QUESTION-1 }

      it 'returns false' do
        expect(user.able_to_ask_question?).to be(false)
      end
    end
  end

  describe '#superstar?' do

    context 'when user has enought points to be a superstar' do

      before(:each) { user.points = User::POINTS_TO_BE_A_SUPERSTAR }

      it 'returns true' do
        expect(user.superstar?).to be(true)
      end
    end

    context 'when user hasn\'t enought points to be a superstar' do

      before(:each) { user.points = User::POINTS_TO_BE_A_SUPERSTAR-1 }

      it 'returns false' do
        expect(user.superstar?).to be(false)
      end
    end
  end

  describe '#points_for_start' do

    context 'when user has nil points' do

      before(:each) { user.points = nil }

      it 'sets default points' do
        user.send(:points_for_start) # points_for_start is private
        expect(user.points).to eq(User::POINTS_FOR_START)
      end
    end

    context 'when user has NOT nil points' do

      before(:each) { user.points = 30 }

      it 'does not change points' do
        user.send(:points_for_start) # points_for_start is private
        expect(user.points).to eq(30)
      end
    end
  end
end
