# include ActionView::Helpers::UrlHelper

class UserSession < Authlogic::Session::Base
  disable_magic_states true

  validate :user_is_active

  def user_is_active
    return true if attempted_record.nil?
    if !attempted_record.active?
      route_helpers = Rails.application.routes.url_helpers
      url = route_helpers.send_validation_url(attempted_record, :only_path => true)
      message = "Your account has not yet been validated. <a href=\"#{url}\">Resend validation email?</a>"
      errors.add(:base, message)
      return false
    end
    true
  end
end
