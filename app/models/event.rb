class Event < Content
  attr_accessible :start, :location

  scope :upcoming, where("start > ?", DateTime.now.beginning_of_day).order("start ASC")
end
