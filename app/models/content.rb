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
  STATES = ['Hidden', 'Normal', 'Sub-feature', 'Feature']

  # Callbacks
  after_save :search_index

  # Set associations
  belongs_to :user
  has_many :images
  has_many :comments, :dependent => :destroy 

  accepts_nested_attributes_for :images, :allow_destroy => true,
    :reject_if => proc { |image_attributes| image_attributes[:id].blank? && image_attributes[:image].blank? }

  # Validations
  validates :title, :summary, :body, :presence => true
  validates :title, :length => { :maximum => 255 }
  validates :summary, :length => { :maximum => 305 }
  validate :require_author
  validate :pseudonym,  :length => { :maximum => 40 },
    :message => "^Author name is too long (maximum length 40 characters)."
  validates :status, :inclusion => { :in => 0...(self::STATES.length) }

  # Scopes
  default_scope :include => :user, :include => :images

  scope :hidden, where(:status => 0)
  scope :visible, where('status > 0')
  scope :normal, where(:status => 1)
  scope :subfeatured, where(:status => 2)
  scope :featured, where(:status => 3)
  scope :featurish, where('status >= 2')
  scope :recent, order('created_at DESC')
  scope :has_image, joins("INNER JOIN images AS image_flag ON image_flag.content_id = contents.id")

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

  def status_name
    Content::STATES[status]
  end

  def hidden?
    status == 0
  end

  def feature?
    status >= 2
  end

  # We manually index to solr so that we can handle any exceptions
  # that might be thrown if, eg., solr is down.
  def search_index
    index!
  rescue Errno::ECONNREFUSED
    logger.error "Solr connection refused: unable to index new content (id: #{id})."
  end
end