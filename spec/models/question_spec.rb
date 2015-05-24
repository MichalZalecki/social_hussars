require 'rails_helper'

describe Question do

  let(:question) { create(:question) }
  let(:question_with_answers) { create(:question, :with_answers) }
  let(:other_user) { create(:user) }

  it 'has a valid factory' do
    expect(build(:question)).to be_valid
  end

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:user) }

  describe 'associations' do

    it { should belong_to(:user) }
    it { should have_many(:answers) }

  end

  describe '#owner?' do

    context 'user is the question author' do

      let(:user) { question.user }

      it 'returns true' do
        expect(question.owner?(user)).to be(true)
      end
    end

    context 'user is NOT the question author' do

      let(:user) { other_user }

      it 'returns false' do
        expect(question.owner?(user)).to be(false)
      end
    end
  end

  describe '#accepted?' do

    context 'question has at least one accepted answers' do

      before(:each) { question_with_answers
                        .answers.first.update(accepted: true) }

      it 'returns true' do
        expect(question_with_answers.accepted?).to be(true)
      end
    end

    context 'question hasn\'t any accepted answers' do

      it 'returns false' do
        expect(question_with_answers.accepted?).to be(false)
      end
    end
  end

  describe '#points_for_asking_question' do

    it 'calls :points_for_asking_question on author' do
      expect(question.user).to receive(:points_for_asking_question)
      question.send(:points_for_asking_question)
    end
  end
end
