class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation, :biography, :display_name

  has_many :articles

  acts_as_authentic do |c|
    # Drupal used plain md5 passwords with no salt, so we are able to
    # seamlessly transition to using SHA512 by setting md5 as the fallback
    # crypto provider.
    c.transition_from_crypto_providers Authlogic::CryptoProviders::MD5
    c.crypto_provider Authlogic::CryptoProviders::Sha512
  end

  def email=(email)
    write_attribute(:email, email.downcase)
  end

  def self.find_by_email(email)
    self.where(email.downcase)
  end
end
