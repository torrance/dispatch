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

  def long_event_date(start_date, end_date)
    logger = Logger.new(STDOUT)
    logger.debug start_date.class
    logger.debug start_date.min

    # Grab the times for each, with the minutes displayed only if they're off the hour.
    start_time = pretty_hour(start_date)
    end_time = pretty_hour(end_date)

    # Start and end dates are both on the same day
    # Need to convert to datetime objects to use this method.
    start_datetime = start_date.to_datetime
    end_datetime = end_date.to_datetime
    if start_datetime === end_datetime
      end_date.strftime("#{start_time}&mdash;#{end_time}, %A #{start_date.day.ordinalize} %B %Y").html_safe
    else
      start_date.strftime("#{start_time} %A #{start_date.day.ordinalize} %B %Y &mdash;") + end_date.strftime("#{end_time} %A #{end_date.day.ordinalize} %B %Y").html_safe
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
