class Content < ActiveRecord::Base
  attr_accessible :title, :summary, :body, :category, :user,
    :pseudonym, :images_attributes, :tag_list

  CATEGORIES = [
    'Protest & Revolution',
    'Ecology & Environment',
    'Workers & Economy',
    'War & Militarism'
  ]

  # Set associations
  belongs_to :user
  has_many :images
  has_many :comments

  accepts_nested_attributes_for :images, :allow_destroy => true,
    :reject_if => proc { |image_attributes| image_attributes[:id].blank? && image_attributes[:image].blank? }

  # Validations
  validates :title, :summary, :body, :presence => true
  validates :title, :length => { :maximum => 255 }
  validates :summary, :length => { :maximum => 305 }
  validate :require_author
  validate :pseudonym,  :length => { :maximum => 40 },
    :message => "^Author name is too long (maximum length 40 characters)."

  # Scopes
  default_scope :include => :user, :include => :images

  scope :hidden, where(:moderation => 0)
  scope :normal, where(:moderation => 1)
  scope :featured, where(:moderation => 2)


  # Public model methods
  def require_author
    if user.blank? && pseudonym.blank?
      errors.add :pseudonym, "^Author name cannot be blank."
    end
  end
  
  def author_name
    if user
      user.display_name
    elsif pseudonym
      pseudonym
    else
      "Anonymous"
    end
  end
  
  def locked?
    Time.now - created_at > 1.week
  end

  def is_author?(user)
    user && self.user == user
  end

  def editable?(user)
    user && (user.is_editor? || is_author?(user) && !locked?)
  end

  def hidden
    moderation = 0
    self
  end

  def normal
    moderation = 1
    self
  end

  def featured
    moderation = 2
    self
  end

  def is_hidden?
    moderation == 0
  end

  def is_normal?
    moderation == 1
  end

  def is_featured?
    moderation == 2
  end
end