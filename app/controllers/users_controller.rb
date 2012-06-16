class UsersController < ApplicationController
  def new
    require_no_user
    @user = User.new
    @user_session = UserSession.new
  end

  def create
    require_no_user
    @user = User.new(params[:user])
    if @user.save_without_session_maintenance # Don't immediately login
      AccountNotifications.activate_account(@user).deliver
      flash[:notice] = "You should receive an email shortly asking you to verify your email address."
      redirect_to :root
    else
      @user_session = UserSession.new
      render :action => :new
    end
  end

  def edit
  end

  def login
    require_no_user
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Welcome back, #{current_user.display_name}"
      redirect_back_or_default :root
    else
      @user = User.new
      render :action => :new
    end
  end

  def logout
    require_user
    current_user_session.destroy
    flash[:notice] = "You have been logged out."
    redirect_back_or_default :root
  end

  def validate
    user = User.find_using_perishable_token(params['token'], 7.days)
    if user
      user.update_attribute(:active, true)
      UserSession.new(user).save
      flash[:notice] = "Success! Your account has been validated."
      redirect_to :root
    else
      flash[:notice] = "Your token has expired or is invalid."
      redirect_to :root
    end
  end
end
