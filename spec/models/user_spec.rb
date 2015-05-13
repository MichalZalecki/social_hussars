require 'rails_helper'

RSpec.describe User, type: :model do

  describe '#to_s' do

    it 'returns an email' do
      user = build(:user)
      expect(user.to_s).to eq(user.email)
    end

  end

end
