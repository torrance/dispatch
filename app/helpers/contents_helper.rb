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
    date.strftime("#{time}, %A #{date.day.ordinalize} %B %Y")
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
