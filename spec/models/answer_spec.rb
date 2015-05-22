require 'rails_helper'

describe Answer do

  subject(:answer){ build(:answer) }

  it 'has a valid factory' do
    is_expected.to be_valid
  end

  it { should validate_presence_of(:contents) }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:question) }

  describe 'associations' do

    it { should belong_to(:user) }
    it { should belong_to(:question) }
  end

  describe '#accept' do

    it 'calls :points_for_accepted_answer on user' do
      user = answer.user
      expect(user).to receive(:points_for_accepted_answer)
      answer.accept
    end

    it 'marks answer as accepted' do
      expect(answer.accepted?).to be(false)
      answer.accept
      expect(answer.accepted?).to be(true)
    end
  end
end
