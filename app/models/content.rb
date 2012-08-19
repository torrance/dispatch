class Content < ActiveRecord::Base
  attr_accessible :title, :summary, :body, :category, :user,
    :pseudonym, :images_attributes, :tag_list

  # Categories are stored in the database by full name.
  CATEGORIES = [
    'Ecology & Environment',
    'Education',
    'Government & Law',
    'History',
    'Immigration & Borders',
    'Maori & Tino Rangitiratanga',
    'Media & Reviews',
    'Opinion & Blogs',
    'People',
    'Police & Prisons',
    'Protest & Revolution',
    'Race & Racism',
    'Science & Technology',
    'Sex & Sexuality',
    'State Repression',
    'War & Militarism',
    'Workers & Economy'
  ]

  # Moderation states are stored in the database as an integer, based on the array
  # indices in Content::MODERATION.
  STATES = ['Hidden', 'Normal', 'Sub-feature', 'Feature']

  # Enable tags for all content
  acts_as_taggable

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
  validates :category, :tag_list, :presence => true, :unless => :event?
  validates :title, :length => { :maximum => 255 }
  validates :summary, :length => { :maximum => 305 }
  validate :pseudonym,  :length => { :maximum => 40 },
    :message => "^Author name is too long (maximum length 40 characters)."
  validates :status, :inclusion => { :in => 0...(self::STATES.length) }
  validates :category, :inclusion => { :in => self::CATEGORIES,
    :message => "^You need to select a valid category." }, :unless => :event?
  validate :tags_limit

  # Scopes
  default_scope :include => :user, :include => :images, :include => :tags

  scope :hidden, where(:status => 0)
  scope :visible, where('status > 0')
  scope :normal, where(:status => 1)
  scope :subfeatured, where(:status => 2)
  scope :featured, where(:status => 3)
  scope :featurish, where('status >= 2')
  scope :recent, order('created_at DESC')
  scope :has_image, joins("INNER JOIN images AS image_flag ON image_flag.content_id = contents.id")

  # Public model methods
  def author_name
    if user.present?
      user.display_name
    elsif pseudonym.present?
      pseudonym
    else
      "Anonymous"
    end
  end
  
  def locked?
    Time.now - created_at > 2.weeks
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

  def tags_limit
    errors.add(:tag_list, "^There are too many tags (maximum 5).") unless tag_list.length <= 5
  end

  def self.search_tags(search)
    tag_counts_on('tags').limit(5).where('tags.name LIKE ?', "%#{search}%")
  end

  def event?
    type == "Event"
  end

  def repost?
    type == "Repost"
  end

  def article?
    type == "Article"
  end

  # We manually index to solr so that we can handle any exceptions
  # that might be thrown if, eg., solr is down.
  def search_index
    index!
  rescue Errno::ECONNREFUSED
    logger.error "Solr connection refused: unable to index new content (id: #{id})."
  end
end