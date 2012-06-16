class ForgottenPasswordsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.forgotten_password(params[:user][:email])
    if @user.errors.any?
      render :action => :new
    else
      AccountNotifications.reset_password(@user).deliver
      flash[:notice] = "Please check your email to reset your password."
      redirect_to :login
    end
  end

  def reset
    user = User.find_using_perishable_token(params[:token], 24.hours)
    if user
      UserSession.new(user).save
      flash[:notice] = "Please update your password."
      redirect_to edit_user_path(user)
    else
      flash[:notice] = "Your reset token has expired or is invalid. Try resetting your password again."
      redirect_to :login
    end
  end
end
