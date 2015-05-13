require 'rails_helper'

RSpec.describe Question, type: :model do

  it 'has a valid factory' do
    expect(build(:question)).to be_valid
  end

  it 'is valid without the contents' do
    expect(build(:question, contents: nil)).to be_valid
  end

  it 'is invalid without the title' do
    expect(build(:question, title: nil)).to be_invalid
  end

  describe 'assotiations' do

    it 'belongs to User' do
      expect(Question.reflect_on_association(:user).macro).to eq(:belongs_to)
    end

    it 'has many Answers' do
      expect(Question.reflect_on_association(:answers).macro).to eq(:has_many)
    end

  end

end
