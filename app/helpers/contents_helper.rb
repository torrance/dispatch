module ContentsHelper
  def link_to_author(article)
    if not article.user.blank?
      link_to article.author_name, article.user
    else
      article.author_name
    end
  end

  def long_article_date(date)
    date.strftime "%A, #{date.day.ordinalize} %B %Y"
  end

  def long_event_date(date)
    # Grab the time, with the minutes displayed only if they're off the hour.
    time = pretty_hour(date)

    today = Date.today
    # Event has been
    if date.past?
      date.strftime "#{time}, #{date.day.ordinalize} %B %Y"
    # Event is today!
    elsif date.today?
      date.strftime "Today, #{time}"
    # Event is tomorrow
    elsif today.tomorrow === date.to_date
      date.strftime "Tomorrow, #{time}"
    # Event is happening this week
    elsif date < today.end_of_week
      date.strftime "#{time}, %A"
    # Event is happening this month, but not this week.
    elsif date < today.end_of_month
      date.strftime "#{time}, #{date.day.ordinalize} %A"
    # Event  is less than 3 months away, but not happening this month.
    elsif date < today.months_since(3)
      date.strftime "#{time}, %A #{date.day.ordinalize} %B"
    # Event has been or is more than 3 months away
    else
      date.strftime "#{time}, #{date.day.ordinalize} %B %Y"
    end
  end

  def pretty_hour(datetime)
    if datetime.min == 0
      datetime.strftime "%l%P"
    else
      datetime.strftime "%l:%M%P"
    end
  end

  def is_event?(model)
    model.class == Event
  end
end
