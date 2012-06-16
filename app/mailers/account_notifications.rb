class AccountNotifications < ActionMailer::Base
  default from: 'Aotearoa Indymedia <do.not.reply@indymedia.org.nz>'

  def activate_account(user)
    mail :to => user.email, :subject => 'Activate your account on Aotearoa Indymedia'
  end
end
