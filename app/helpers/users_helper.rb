module UsersHelper
  def user_stats(user)
    date_joined = user.created_at.strftime "Member since <strong>%B %Y</strong>."
    items = user.contents.count
    comments = user.comments.count

    if items > 0 && comments > 0
      "#{date_joined} Has published <strong>#{items} items</strong> and has made <strong>#{comments} comments</strong>.".html_safe
    elsif items > 0
      "#{date_joined} Has published <strong>#{items} items</strong> but hasn't made any comments yet.".html_safe
    elsif comments > 0
      "#{date_joined} Has has made <strong>#{comments} comments</strong> but has yet published any items.".html_safe
    else
      "#{date_joined} Hasn't yet published any items or comments.".html_safe
    end
  end

  def comment_date(date)
    date.strftime "%e %B %Y"
  end
end
