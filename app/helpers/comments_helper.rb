module CommentsHelper
  def comment_date(date)
    if date < date + 7.days
      time_ago_in_words(date)
    else
      date.strftime "#{date.day.ordinalize} %B %Y"
    end
  end
end
