require 'rails_helper'

RSpec.describe Answer, type: :model do

  it 'has a vaild factory' do
    expect(build(:answer)).to be_valid
  end

  it 'is invalid without the contents' do
    expect(build(:answer, contents: nil)).to be_invalid
  end

end
