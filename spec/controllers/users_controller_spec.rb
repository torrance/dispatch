require 'spec_helper'

describe UsersController do
  fixtures :users

  describe 'GET #new' do
    it 'renders the :new template' do
      get :new
      response.should render_template :new
    end

    it 'creates a new user object' do
      get :new
      assigns(:user).instance_of?(User).should be_true
    end

    it 'creates a new user session object' do
      get :new
      assigns(:user_session).instance_of?(UserSession).should be_true
    end
  end

  describe 'POST #create' do
    context "with valid attributes" do
      it 'creates a new user' do
        expect{
          post :create, user: attributes_for(:user)
        }.to change(User, :count).by(1)
      end

      it 'creates an inactive user' do
        post :create, user: attributes_for(:user)
        assigns(:user).active?.should be_false
      end

      it 'redirects to login page' do
        post :create, user: attributes_for(:user)
        response.should redirect_to login_url
      end

      it 'sends a validation email' do
        post :create, user: attributes_for(:user)
        user = assigns(:user)
        open_last_email.should be_delivered_to user.pretty_email_address
        open_last_email.should have_subject "Activate your account"
      end
    end

    context 'with invalid attributes' do
      it 'does not create a duplicate user' do
        user = create(:user)
        expect{
          post :create, user: attributes_for(:user, :email => user.email)
        }.to_not change(User, :count)
      end

      it 'does not create a user with short password' do
        expect{
          post :create, user: attributes_for(:user_with_short_password)
        }.to_not change(User, :count)
      end

      it 'renders the :new template' do
        post :create, user: attributes_for(:user_with_short_password)
        response.should render_template :new
      end
    end
  end

  describe 'POST #login' do
    context "with valid attributes" do
      it "creates a new session" do
        user = create(:active_user)
        post :login, user_session: { email: user.email, password: 'password' }
        assigns(:user_session).should be_valid
      end

      # The drupal user is created via a fixture and is user 1.
      it "creates a session for a user with a Drupal 6 md5 encoded password" do
        post :login, user_session: { email: 'drupaluser@domain.com', password: 'password' }
        assigns(:user_session).should be_valid
      end
    end

    context "with invalid attributes" do
      it "does not create a session with incorrect password" do
        user = create(:active_user)
        post :login, user_session: { email: user.email, password: 'incorrect' }
        assigns(:user_session).should_not be_valid
      end

      it "does not create a session for a non-existent user" do
        create(:active_user, email: 'user@domain.com')
        post :login, user_session: { email: 'not@here.com', password: 'password' }
        assigns(:user_session).should_not be_valid
      end

      it "does not create a session for an inactive user" do
        user = create(:user)
        post :login, user_session: { email: user.email, password: 'password' }
        assigns(:user_session).should_not be_valid
      end

    end
  end

  describe 'GET #validate' do
    context "with valid perishable token" do
      before :each do
        @user = create(:user)
        get :validate, token: @user.perishable_token
      end

      it "loads the assocated user" do
        assigns(:user).should be_valid
      end

      it "sets the user to active" do
        @user.reload.active?.should be_true
      end

      it "creates a user session" do 
        assigns(:user_session).should be_valid
      end

      it "redirects to the front page" do
        response.should redirect_to root_url
      end
    end

    context "with invalid perishable token" do
      before :each do
        get :validate, token: '12345'
      end

      it "does not load a user" do
        assigns(:user).should be_false
      end


      it "does not create a user session" do
        assigns(:user_session).should be_nil
      end

      it "redirects to the front page" do
        response.should redirect_to root_url
      end
    end
  end

  describe 'GET #send_validation' do
    context "user is inactive" do
      it 'sends a validation email' do
        user = create(:user)
        get :send_validation, id: user.id
        open_last_email.should be_delivered_to user.pretty_email_address
        open_last_email.should have_subject "Activate your account"
      end

      it 'redirects them to the login page' do
        user = create(:user)
        get :send_validation, id: user.id
        response.should redirect_to login_url
      end
    end

    context "does not exist" do
      it 'raises a 404 error' do
        expect{
          get :send_validation, id: 12345
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "is already active" do
      it 'does not send an email' do
        user = create(:active_user)
        get :send_validation, id: user.id
        # This relies on faker producing uinique users and email addresses.
        # This test may therefore rarely fail.
        open_last_email.should_not be_delivered_to user.pretty_email_address
      end

      it 'redirects them to the login page' do
        user = create(:active_user)
        get :send_validation, id: user.id
        response.should redirect_to login_url
      end
    end
  end
end
