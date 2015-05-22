require 'rails_helper'

describe UsersController do

  describe 'GET #show' do

    let(:user) { create(:user) }
    before(:each) { get :show, id: user.id }

    it { should respond_with(:success) }
    it { should render_template(:show) }

    it 'assings user to @user' do
      expect(assigns(:user)).to eq(user)
    end

  end

end
