require 'rails_helper'

describe Answer do

  it 'has a vaild factory' do
    expect(build(:answer)).to be_valid
  end

  it { should validate_presence_of(:contents) }

  describe 'associations' do

    it { should belong_to(:user) }
    it { should belong_to(:question) }

  end
end
