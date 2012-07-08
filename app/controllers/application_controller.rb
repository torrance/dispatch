class ApplicationController < ActionController::Base
  protect_from_forgery

  include SimpleCaptcha::ControllerHelpers

  helper_method :current_user_session, :current_user
  
  private
    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end
    
    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.record
    end

    def authenticate_admin_user!
      if !current_user
        redirect_to login_path, :notice => "You are trying to access a restricted area. Please login first."
      elsif !current_user.is_editor?
        redirect_to :root, :notice => "You do not have permission to access the administration area."
      end
    end
    
    def require_user
      unless current_user
        flash[:notice] = "You must be logged in to access this page"
        redirect_to login_path
      end
    end

    def require_no_user
      if current_user
        flash[:notice] = "You must be logged out to access this page"
        redirect_back_or_default :root
      end
    end
    
    def redirect_back_or_default(default)
      redirect_to :back
    rescue ActionController::RedirectBackError
      redirect_to default
    end

    def valid_captcha?(model)
      if simple_captcha_valid?
        true
      else
        # We also test for valid model, so that we can preset user with
        # all validation errors in one lot.
        model.valid?
        model.errors.add(:captcha, "^The code you've entered does not match the text in the image.")
        false
      end
    end
end
