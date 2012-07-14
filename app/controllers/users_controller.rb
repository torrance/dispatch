class UsersController < ApplicationController
  def new
    #require_no_user
    @user = User.new
    @user_session = UserSession.new
  end

  def create
    #require_no_user
    @user = User.new(params[:user])

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
  end

  def show
    @user = User.find(params[:id])
    @contents = Content.recent.where(:user_id => @user)
    @comments = Comment.recent.where(:user_id => @user).limit(3)
  end

  def login
    #require_no_user
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      redirect_to :root
    else
      @user = User.new
      render :action => :new
    end
  end

  def logout
    #require_user
    current_user_session.destroy
    redirect_back_or_default :root
  end

  def validate
    @user = User.find_using_perishable_token(params[:token], 7.days)
    if @user
      @user.update_attribute(:active, true)
      @user_session = UserSession.create(@user)
      flash[:notice] = "Success! Your account has been validated."
      redirect_to :root
    else
      flash[:notice] = "Your token has expired or is invalid."
      redirect_to :root
    end
  end

  def send_validation
    user = User.find(params[:id])
    if user.active?
      flash[:notice] = "This account is already active."
    else
      AccountNotifications.activate_account(user).deliver
      flash[:notice] = "Your validation email has been resent."
    end
    redirect_to :login
  end
end
