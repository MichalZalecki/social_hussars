require 'rails_helper'

describe PageController do

  describe 'GET #home' do

    before(:each) { get :home }

    it { should respond_with(:success) }
    it { should render_template(:home) }
  end

  describe 'GET #leaderboard' do

    before(:each) { get :leaderboard }
    let(:user) { create(:user) }

    it { should respond_with(:success) }
    it { should render_template(:leaderboard) }

    it 'assigns all users to @users' do
      expect(assigns(:users)).to eq([user])
    end
  end
end
