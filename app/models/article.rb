class Article < ActiveRecord::Base
  attr_accessible :title, :summary, :body, :category, :user, :images_attributes

  belongs_to :user
  has_many :images

  accepts_nested_attributes_for :images

  default_scope :include => :user, :include => :images

  CATEGORIES = [
    'Protest & Revolution',
    'Ecology & Environment',
    'Workers & Economy',
    'War & Militarism'
  ]

  validates :title, :summary, :body, :category, :presence => true
  validates :title, :length => { :maximum => 255 }
  validates :summary, :length => { :maximum => 305 }
  validates :category, :inclusion => { :in => self::CATEGORIES,
    :message => "%{value} is not a valid category" }

end
