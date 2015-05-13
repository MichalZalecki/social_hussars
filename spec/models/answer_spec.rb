require 'rails_helper'

RSpec.describe Answer, type: :model do

  it 'has a vaild factory' do
    expect(build(:answer)).to be_valid
  end

  it 'is invalid without the contents' do
    expect(build(:answer, contents: nil)).to be_invalid
  end

  describe 'associations' do

    it 'belongs to User' do
      expect(Answer.reflect_on_association(:user).macro).to eq(:belongs_to)
    end

    it 'belongs to Question' do
      expect(Answer.reflect_on_association(:question).macro).to eq(:belongs_to)
    end

  end

end
