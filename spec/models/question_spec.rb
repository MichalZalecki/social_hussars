require 'rails_helper'

describe Question do

  it 'has a valid factory' do
    expect(build(:question)).to be_valid
  end

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:user) }

  describe 'associations' do

    it { should belong_to(:user) }
    it { should have_many(:answers) }

  end
end
