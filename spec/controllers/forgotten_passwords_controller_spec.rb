require 'spec_helper'

describe ForgottenPasswordsController do
  describe 'GET #new' do
    it 'renders the :new template' do
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    it 'executes User.forgotten_password without error' do
      user = create(:active_user)
      post :create, user: user.attributes
      expect(assigns :user).to have(0).errors
    end

    it 'sends reset password email' do
      user = create(:active_user)
      post :create, user: user.attributes
      expect(open_last_email).to be_delivered_to user.pretty_email_address
      expect(open_last_email).to have_subject "Reset your password"
    end

    it 'rejects non-existent emails' do
      user = build(:active_user)
      post :create, user: user.attributes
      expect(assigns :user).to have(1).errors
    end

    it 'rejects inactive accounts' do
      user = create(:user)
      post :create, user: user.attributes
      expect(assigns :user).to have(1).errors
    end

    it 'redirects to the login page' do
      user = create(:active_user)
      post :create, user: user.attributes
      expect(response).to redirect_to login_url
    end
  end

  describe 'GET #reset' do
    context "with valid token" do
      it 'creates a valid session' do
        user = create(:active_user)
        get :reset, token: user.perishable_token
        expect(assigns :user_session).to be_valid
      end

      it 'redirects to the login page' do
        user = create(:active_user)
        get :reset, token: user.perishable_token
        expect(response).to redirect_to edit_user_url(user)
      end
    end

    context "with invalid token" do
      it 'does not create a session' do
        get :reset, token: '13456'
        expect(assigns :user_session).to be_nil
      end

      it 'redirects to the login page' do
        get :reset, token: '13456'
        expect(response).to redirect_to login_url
      end

    end
  end
end
