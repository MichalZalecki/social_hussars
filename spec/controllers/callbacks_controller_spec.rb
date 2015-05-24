require 'rails_helper'

describe CallbacksController do

  # IT WILL BE AN INTEGRATION TEST

  # more info at
  # https://github.com/intridea/omniauth/wiki/Integration-Testing

  # let(:user) { create(:user) }
  # let(:new_user) { build(:user) }

  # before(:each) do
  #   request.env["devise.mapping"] = Devise.mappings[:user]
  #   OmniAuth.config.test_mode = true
  # end

  # describe 'GET|POST github' do

  #   before do
  #     OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
  #       provider: :github,
  #       uid:'12345',
  #       info: {
  #         nickname: new_user.username,
  #         email: new_user.email
  #       }
  #     })
  #     request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:github]
  #   end

  #   it 'adds a new user' do
  #     expect { get :github }.to change(User, :count).by(1)
  #   end

  # end

  let(:user) { create(:user) }

  before do
    request.env["devise.mapping"] = Devise.mappings[:user]
    expect(User).to receive(:from_omniauth) { user }
  end

  describe 'GET #github' do

    before(:each) { get :github }

    it { should redirect_to root_path }
    it 'signs in the user' do
      expect(controller.current_user).to eq(user)
    end
  end

end
