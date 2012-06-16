class AccountNotifications < ActionMailer::Base
  default from: 'Aotearoa Indymedia <do.not.reply@indymedia.org.nz>'

  def activate_account(user)
    @user = user
    mail :to => "#{user.display_name} <#{user.email}>", :subject => 'Activate your account'
  end

  def reset_password(user)
    @user = user
    mail :to => "#{user.display_name} <#{user.email}>", :subject => "Reset your password"
  end
end
