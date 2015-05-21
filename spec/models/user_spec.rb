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

    it 'returns an email' do
      user = build(:user)
      expect(user.to_s).to eq(user.email)
    end
  end

  describe '#starting_points' do

    it 'sets default points' do
      user = build(:user)
      user.send(:starting_points) # starting_points is private
      expect(user.points).to eq(100)
    end
  end
end
