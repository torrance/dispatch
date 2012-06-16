class UsersController < ApplicationController
  def new
    @user = User.new
    @user_session = UserSession.new
  end

  def login
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Login successful!"
      redirect_back_or_default '/article/2'
    else
      render :action => :new
    end
  end

  def logout
    current_user_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_back_or_default new_user_session_url
  end
end
