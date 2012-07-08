module FrontpageHelper

  def feature_date(date)
    date.strftime "#{date.day.ordinalize} %B %Y"
  end

  def print_newswire_date(content)
    date = content.created_at

    # We only want to print a date if it differs from the date immediatelty
    # before. Therefore, we store previous dates in an instance variable and
    # and hope that this doesn't persist between requests.
    if @last_date && date.to_date === @last_date
      @last_date = date.to_date
      return
    else
      @last_date = date.to_date
    end
    
    today = Date.today

    # Event is today
    if date.today?
      "Today"
    # Event is yesterday
    elsif today.yesterday === date.to_date
      "Yesterday"
    # All other dates
    else
      date.strftime "%e %B %Y"
    end
  end
end