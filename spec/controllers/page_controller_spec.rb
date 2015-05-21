require 'rails_helper'

describe PageController do

  describe "GET #home" do

    before(:each) { get :home }

    it { should respond_with(:success) }
    it { should render_template(:home) }

  end

end
