require 'rails_helper'

RSpec.describe User, type: :model do

  subject(:user){ build(:user) }
  let(:answer) { create(:answer) }
  let(:voter) { create(:user) }

  it 'has a valid factory' do
    is_expected.to be_valid
  end

  describe 'associations' do
    it { should have_many(:questions) }
    it { should have_many(:answers) }
  end

  describe '#to_s' do

    it 'returns an email and points' do
      expect(user.to_s).to eq("#{user.email} (#{user.points})")
    end
  end

  describe '#points_for_start' do

    it 'sets default points' do
      user.send(:points_for_start) # points_for_start is private
      expect(user.points).to eq(100)
    end
  end

  describe '#points_for_upvote' do

    context 'voter did NOT downvote answer before' do
      it 'gives points for upvote' do
        expect { user.points_for_upvote(voter, answer) }.to change(user, :points).by(5)
      end
    end

    context 'voter downvoted answer before' do

      before(:each) { answer.downvote_from voter }

      it 'gives points for upvote' do
        expect { user.points_for_upvote(voter, answer) }.to change(user, :points).by(10)
      end
    end
  end

  describe '#points_for_downvote' do

    context 'voter did NOT upvote answer before' do
      it 'takes points for upvote' do
        expect { user.points_for_downvote(voter, answer) }.to change(user, :points).by(-5)
      end
    end

    context 'voter upvoteed answer before' do

      before(:each) { answer.liked_by voter }

      it 'takes points for upvote' do
        expect { user.points_for_downvote(voter, answer) }.to change(user, :points).by(-10)
      end
    end
  end

  describe '#points_for_accepted_answer' do

    it 'takes points for downvote' do
      expect { user.points_for_accepted_answer }.to change(user, :points).by(25)
    end
  end
end
