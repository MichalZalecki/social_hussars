require 'rails_helper'

RSpec.describe User, type: :model do

  it 'has a valid factory' do
    expect(build(:user)).to be_valid
  end

  describe 'associations' do
    it { should have_many(:questions) }
    it { should have_many(:answers) }
  end

  describe '#to_s' do

    it 'returns an email and points' do
      user = build(:user)
      expect(user.to_s).to eq("#{user.email} (#{user.points})")
    end
  end

  describe '#starting_points' do

    it 'sets default points' do
      user = build(:user)
      user.send(:starting_points) # starting_points is private
      expect(user.points).to eq(100)
    end
  end

  describe '#points_for_upvote' do

    it 'gives points for upvote' do
      user = build(:user)
      expect { user.points_for_upvote }.to change(user, :points).by(5)
    end
  end

  describe '#points_for_downvote' do

    it 'takes points for downvote' do
      user = build(:user)
      expect { user.points_for_downvote }.to change(user, :points).by(-5)
    end
  end

  describe '#points_for_accepted_answer' do

    it 'takes points for downvote' do
      user = build(:user)
      expect { user.points_for_accepted_answer }.to change(user, :points).by(25)
    end
  end
end
