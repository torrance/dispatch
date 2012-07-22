class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation, :biography,
    :display_name, :as => [:default, :editor]
  attr_accessible :role, :active, :as => :editor

  ROLES = %w(Normal Editor)

  has_many :contents
  has_many :comments

  scope :recent, order("created_at DESC")

  acts_as_authentic do |c|
    # Drupal used plain md5 passwords with no salt, so we are able to
    # seamlessly transition to using SHA512 by setting md5 as the fallback
    # crypto provider.
    c.transition_from_crypto_providers Authlogic::CryptoProviders::MD5
    c.crypto_provider Authlogic::CryptoProviders::Sha512
    c.require_password_confirmation false
    c.validates_length_of_password_field_options :minimum => 6, :if => :require_password?
  end

  def self.can_reset_password?(email)
    user = self.find_by_smart_case_login_field(email)
    if user && user.active?
      user
    else
      false
    end
  end

  def pretty_email_address
    "#{display_name} <#{email}>"
  end

  def editor?
    role == 1
  end
end
