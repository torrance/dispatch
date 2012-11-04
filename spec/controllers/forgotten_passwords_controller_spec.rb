require 'spec_helper'

describe ForgottenPasswordsController do
  describe 'GET #new' do
    it 'renders the :new template' do
      get :new
      response.should render_template :new
    end
  end

  describe 'POST #create' do
    it 'executes User.forgotten_password without error' do
      user = create(:active_user)
      post :create, user: user.attributes
      assigns(:user).errors.any?.should be false
    end

    it 'sends reset password email' do
      user = create(:active_user)
      post :create, user: user.attributes
      open_last_email.should be_delivered_to user.pretty_email_address
      open_last_email.should have_subject "Reset your password"
    end

    it 'rejects non-existent emails' do
      user = build(:active_user)
      post :create, user: user.attributes
      assigns(:user).errors.any?.should be_true
    end

    it 'rejects inactive accounts' do
      user = create(:user)
      post :create, user: user.attributes
      assigns(:user).errors.any?.should be_true
    end

    it 'redirects to the login page' do
      user = create(:active_user)
      post :create, user: user.attributes
      response.should redirect_to login_url
    end
  end

  describe 'GET #reset' do
    context "with valid token" do
      it 'creates a valid session' do
        user = create(:active_user)
        get :reset, token: user.perishable_token
        assigns(:user_session).should be_valid
      end

      it 'redirects to the login page' do
        user = create(:active_user)
        get :reset, token: user.perishable_token
        response.should redirect_to edit_user_url(user)
      end
    end

    context "with invalid token" do
      it 'does not create a session' do
        get :reset, token: '13456'
        assigns(:user_session).should be_nil
      end

      it 'redirects to the login page' do
        get :reset, token: '13456'
        response.should redirect_to login_url
      end

    end
  end
end
