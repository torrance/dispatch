class UsersController < ApplicationController
  def new
    if current_user
      flash[:notice] = "You are already logged in."
      redirect_to :root
    end
    @user = User.new
    @user_session = UserSession.new
  end

  def create
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

  def login
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
    current_user_session.destroy
    flash[:notice] = "You have logged out."
    redirect_back_or_default :root
  end
end
