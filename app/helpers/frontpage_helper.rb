module FrontpageHelper
  def feature_date(date)
    date.strftime "#{date.day.ordinalize} %B %Y"
  end

  def short_newswire_date(date)
    # We only want to print a date if it differs from the date immediatelty
    # before. Therefore, we store previous dates in an instance variable and
    # and hope that this doesn't persist between requests.
    if @last_date && date.to_date === @last_date
      @last_date = date.to_date
      return
    else
      @last_date = date.to_date
    end

    short_content_date(date)
  end
end