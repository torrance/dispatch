class Article < Content
  validates :category, :presence => true
  validates :category, :inclusion => { :in => self::CATEGORIES,
    :message => "%{value} is not a valid category" }
end
