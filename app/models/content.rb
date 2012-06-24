class Content < ActiveRecord::Base
  attr_accessible :title, :summary, :body, :category, :user, :pseudonym, :images_attributes

  belongs_to :user
  has_many :images

  accepts_nested_attributes_for :images, :allow_destroy => true,
    :reject_if => proc { |image_attributes| image_attributes[:image].blank? }

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
  validate :require_author
  validate :pseudonym,  :length => { :maximum => 40 }, :message => "^Author name is too long (maximum length 40 characters)."

  def require_author
    if user.blank? && pseudonym.blank?
      errors.add :pseudonym, "^Author name cannot be blank."
    end
  end
  
  def author_name
    if not user.blank?
      user.display_name
    elsif not pseudonym.blank?
      pseudonym
    else
      "Anonymous"
    end
  end
  
  def locked?
    Time.now - created_at > 1.week
  end

  def editable?(user)
    if user.blank?
      false
    elsif user.is_editor?
      true
    elsif user == self.user and not locked?
      true
    else
      false
    end
  end
end