class ApplicationController < ActionController::Base
  protect_from_forgery

  include SimpleCaptcha::ControllerHelpers

  helper_method :current_user_session, :current_user, :content_path

  rescue_from CanCan::AccessDenied, :with => :render_403
  rescue_from ActionController::RoutingError, :with => :render_404
  rescue_from AbstractController::ActionNotFound, :with => :render_404
  rescue_from ActiveRecord::RecordNotFound, :with => :render_404

  def render_403
    render 'application/403', :status => 403
  end

  def render_404
    render 'application/404', :status => 404
  end
  
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
      unless current_user && current_user.editor?
        raise CanCan::AccessDenied
      end
    end
    
    def redirect_back_or_default(default)
      redirect_to :back
    rescue ActionController::RedirectBackError
      redirect_to default
    end

    def valid_captcha?(model)
      if  simple_captcha_valid? || Rails.env.test?
        true
      else
        # We also test for valid model, so that we can preset user with
        # all validation errors in one lot.
        model.valid?
        model.errors.add(:captcha, "^The code you've entered does not match the text in the image.")
        false
      end
    end

    def not_spam?(model)
      if model.spam?
        # We also test for valid model, so that we can preset user with
        # all validation errors in one lot.
        model.errors.add(:base, "We're sorry, but your submission has been identified as spam. You will not be able to publish it.")
        false
      else
        true
      end
    end

    def content_path(content, args={})
      if content.hidden?
        submission_path content, args
      else
        polymorphic_path content, args
      end
    end
end
