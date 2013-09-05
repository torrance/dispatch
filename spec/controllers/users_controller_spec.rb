require 'spec_helper'

describe UsersController do
  fixtures :users

  describe 'GET #new' do
    it 'renders the :new template' do
      get :new
      expect(response).to render_template :new
    end

    it 'creates a new user object' do
      get :new
      expect(assigns :user).to be_a_new(User)
    end

    it 'creates a new user session object' do
      get :new
      expect(assigns :user_session).to be_a_new(UserSession)
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
        expect(assigns(:user).active?).to be_false
      end

      it 'redirects to login page' do
        post :create, user: attributes_for(:user)
        expect(response).to redirect_to login_url
      end

      it 'sends a validation email' do
        post :create, user: attributes_for(:user)
        user = assigns(:user)
        expect(open_last_email).to be_delivered_to user.pretty_email_address
        expect(open_last_email).to have_subject "Activate your account"
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
        expect(response).to render_template :new
      end
    end
  end

  describe 'POST #login' do
    context "with valid attributes" do
      it "creates a new session" do
        user = create(:active_user)
        post :login, user_session: { email: user.email, password: 'password' }
        expect(assigns :user_session).to be_valid
      end

      # The drupal user is created via a fixture and is user 1.
      it "creates a session for a user with a Drupal 6 md5 encoded password" do
        post :login, user_session: { email: 'drupaluser@domain.com', password: 'password' }
        expect(assigns :user_session).to be_valid
      end
    end

    context "with invalid attributes" do
      it "does not create a session with incorrect password" do
        user = create(:active_user)
        post :login, user_session: { email: user.email, password: 'incorrect' }
        expect(assigns :user_session).to_not be_valid
      end

      it "does not create a session for a non-existent user" do
        create(:active_user, email: 'user@domain.com')
        post :login, user_session: { email: 'not@here.com', password: 'password' }
        expect(assigns :user_session).to_not be_valid
      end

      it "does not create a session for an inactive user" do
        user = create(:user)
        post :login, user_session: { email: user.email, password: 'password' }
        expect(assigns :user_session).to_not be_valid
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
        expect(assigns :user).to be_valid
      end

      it "sets the user to active" do
        expect(@user.reload.active?).to be_true
      end

      it "creates a user session" do 
        expect(assigns :user_session).to be_valid
      end

      it "redirects to their user edit page" do
        user = assigns(:user)
        expect(response).to redirect_to edit_user_path(user)
      end
    end

    context "with invalid perishable token" do
      before :each do
        get :validate, token: '12345'
      end

      it "does not load a user" do
        expect(assigns :user).to be_false
      end


      it "does not create a user session" do
        expect(assigns :user_session).to be_nil
      end

      it "redirects to the front page" do
        expect(response).to redirect_to root_url
      end
    end
  end

  describe 'GET #send_validation' do
    context "user is inactive" do
      it 'sends a validation email' do
        user = create(:user)
        get :send_validation, id: user.id
        expect(open_last_email).to be_delivered_to user.pretty_email_address
        expect(open_last_email).to have_subject "Activate your account"
      end

      it 'redirects them to the login page' do
        user = create(:user)
        get :send_validation, id: user.id
        expect(response).to redirect_to login_url
      end
    end

    context "user does not exist" do
      it 'raises a 404 error' do
        get :send_validation, id: 12345
        expect(response.status).to eq(404)
      end
    end

    context "user is already active" do
      it 'does not send an email' do
        user = create(:active_user)
        get :send_validation, id: user.id
        # This relies on faker producing uinique users and email addresses.
        # This test may therefore rarely fail.
        expect(open_last_email).to_not be_delivered_to user.pretty_email_address
      end

      it 'redirects them to the login page' do
        user = create(:active_user)
        get :send_validation, id: user.id
        expect(response).to redirect_to login_url
      end
    end
  end
end
