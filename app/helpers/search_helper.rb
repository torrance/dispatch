module SearchHelper
  def search_date(date)
    date.strftime "#{date.day.ordinalize} %b %Y"
  end
end
