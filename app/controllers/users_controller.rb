class UsersController < ApplicationController
  check_authorization # Ensure cancan validation on every controller method
  skip_authorization_check :only => [:logout, :validate, :send_validation]

  def new
    @user = User.new
    authorize! :create, @user
    @user_session = UserSession.new
  end

  def create
    @user = User.new(params[:user])
    authorize! :create, @user

    if valid_captcha?(@user) && @user.save_without_session_maintenance # Don't immediately login
      AccountNotifications.activate_account(@user).deliver
      flash[:notice] = "You should receive an email shortly asking you to verify your email address."
      redirect_to :login
    else
      @user_session = UserSession.new
      render :action => :new
    end
  end

  def edit
    @user = User.find(params[:id])
    authorize! :update, @user
  end

  def update
    @user = User.find(params[:id])
    authorize! :update, @user

    if @user.update_attributes(params[:user])
      redirect_to @user, :notice => 'Your user settings have been successfully updated.'
    else
      render :action => :edit
    end
  end

  def show
    @user = User.find(params[:id])
    authorize! :read, @user

    @contents = Content.recent.where(:user_id => @user).page(params[:page]).per(5)
    @comments = Comment.recent.where(:user_id => @user).limit(3)

    respond_to do |format|
      format.html
      format.js
    end
  end

  def login
    @user_session = UserSession.new(params[:user_session])
    authorize! :create, @user_session

    if @user_session.save
      redirect_to :root
    else
      @user = User.new
      render :action => :new
    end
  end

  def logout
    current_user_session.destroy
    redirect_to :root
  end

  def validate
    @user = User.find_using_perishable_token(params[:token], 7.days)
    if @user
      @user.update_attribute(:active, true)
      @user_session = UserSession.create(@user)
      redirect_to edit_user_path(@user), :notice => "Success! Your account has been validated."
    else
      redirect_to :root, :notice => "Your token has expired or is invalid."
    end
  end

  def send_validation
    user = User.find(params[:id])
    if user.active?
      redirect_to :login, :notice => "This account is already active."
    else
      AccountNotifications.activate_account(user).deliver
      redirect_to :login, :notice => "Your validation email has been resent."
    end
  end
end
