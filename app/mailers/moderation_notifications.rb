class ModerationNotifications < ActionMailer::Base
  default to: User.editors.map(&:pretty_email_address).join(', '),
          from: 'Aotearoa Indymedia <noreply@indymedia.org.nz>'

  def vote(vote, diff)
    if diff == 1
      @action = "voted for"
    elsif diff == -1
      @action = "voted against"
    else
      # Ideally we won't get here, but just in case.
      @action = "voted on (#{diff})"
    end

    @user = vote.user
    @content = vote.content

    mail subject: "#{@user.display_name} #{@action} #{@content.title}"
  end
end
