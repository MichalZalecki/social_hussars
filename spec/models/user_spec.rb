require 'rails_helper'

RSpec.describe User, type: :model do

  it 'has a valid factory' do
    expect(build(:user)).to be_valid
  end

  describe '#to_s' do

    it 'returns an email' do
      user = build(:user)
      expect(user.to_s).to eq(user.email)
    end

  end

  describe 'associations' do

    it 'has many to Questions' do
      expect(User.reflect_on_association(:questions).macro).to eq(:has_many)
    end

    it 'has many to Answers' do
      expect(User.reflect_on_association(:answers).macro).to eq(:has_many)
    end

  end

end
