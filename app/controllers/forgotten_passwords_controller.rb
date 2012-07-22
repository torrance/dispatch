class ForgottenPasswordsController < ApplicationController
  check_authorization # Ensure cancan validation on every controller method
  skip_authorization_check :only => [:reset]

  def new
    @user = User.new
    @user_session = current_user_session || UserSession.new
    authorize! :create, @user_session
  end

  def create
    @user = User.can_reset_password?(params[:user][:email])
    @user_session = current_user_session || UserSession.new
    authorize! :create, @user_session

    if @user
      @user.reset_perishable_token!
      AccountNotifications.reset_password(@user).deliver
      flash[:notice] = "Please check your email to reset your password."
      redirect_to :login
    else
      @user = User.new
      @user.errors.add(:base, "That email address either does not exist or has not been activated.")
      render :action => :new
    end
  end

  def reset
    user = User.find_using_perishable_token(params[:token], 24.hours)
    if user
      # TODO: We save @user_session to an instance variable solely so that we can
      # test the success of failure of this method in rspec. This should probably
      # be fixed.
      @user_session = UserSession.create(user)
      redirect_to edit_user_path(user), :notice => "Please update your password."
    else
      redirect_to :login, :notice => "Your reset token has expired or is invalid. Try resetting your password again."
    end
  end
end
