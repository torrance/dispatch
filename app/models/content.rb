class Content < ActiveRecord::Base
  attr_accessible :title, :summary, :body, :category, :user,
    :pseudonym, :images_attributes, :tag_list

  # Categories are stored in the database by full name.
  CATEGORIES = [
    'Protest & Revolution',
    'Ecology & Environment',
    'Workers & Economy',
    'War & Militarism'
  ]

  # Moderation states are stored in the database as an integer, based on the array
  # indices in Content::MODERATION.
  MODERATION = %w(Hidden Normal Featured)

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
  validates :moderation, :inclusion => { :in => 0...(self::MODERATION.length) }

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

  def moderation_name
    Content::MODERATION[moderation]
  end
end