class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation, :biography, :display_name, :active

  has_many :articles

  acts_as_authentic do |c|
    # Drupal used plain md5 passwords with no salt, so we are able to
    # seamlessly transition to using SHA512 by setting md5 as the fallback
    # crypto provider.
    c.transition_from_crypto_providers Authlogic::CryptoProviders::MD5
    c.crypto_provider Authlogic::CryptoProviders::Sha512
    c.require_password_confirmation false
    c.validates_length_of_password_field_options :minimum => 6, :if => :require_password?
  end

  def self.forgotten_password(email)
    user = self.find_by_smart_case_login_field(email)
    if user && user.active?
      user.reset_perishable_token!
      user
    else
      user = User.new
      user.errors.add(:email, "does not exist")
      user
    end
  end
end
