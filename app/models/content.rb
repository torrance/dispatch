class Content < ActiveRecord::Base
  attr_accessible :title, :summary, :body, :category, :user,
    :pseudonym, :images_attributes, :tag_list, :as => [:default, :editor]
  attr_accessible :created_at, :user_id, :status, :as => :editor

  # Categories are stored in the database by full name.
  CATEGORIES = [
    'Ecology & Environment',
    'Education',
    'Government & Law',
    'History',
    'Immigration & Borders',
    'Maori & Tino Rangatiratanga',
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
  STATES = ['Normal', 'Sub-feature', 'Feature']

  # Enable and configure rakismet
  include Rakismet::Model
  rakismet_attrs :content => :body, :author => :author_name

  # Enable tags for all content
  acts_as_taggable

  # Callbacks
  after_save :search_index

  # Set associations
  belongs_to :user
  belongs_to :hidden_user, :class_name => 'User'
  has_many :images
  has_many :comments, :dependent => :destroy
  has_many :votes, :dependent => :destroy

  accepts_nested_attributes_for :images, :allow_destroy => true,
    :reject_if => proc { |image_attributes| image_attributes[:id].blank? && image_attributes[:image].blank? }

  # Validations
  validates :title, :summary, :presence => true
  validates :body, :presence => true, :unless => :repost?
  validates :category, :tag_list, :presence => true, :unless => :event?
  validates :title, :length => { :maximum => 255 }
  validates :summary, :length => { :maximum => 255 }
  validate :pseudonym,  :length => { :maximum => 40 },
    :message => "^Author name is too long (maximum length 40 characters)."
  validates :status, :inclusion => { :in => 0...(self::STATES.length) }
  validates :category, :inclusion => {
    :in => self::CATEGORIES,
    :message => "^You need to select a valid category."
  }, :unless => :event?
  validate :tags_limit
  validate :all_caps
  validates :body, :language => {
    :language => :en,
    :message => "^We're sorry, but your submission has been identified as spam. You will not be able to publish it."
  }, :if => "Rails.env.production?"

  # Scopes
  default_scope :include => :user, :include => :images, :include => :tags

  scope :hidden, where(:hidden => true)
  scope :visible, where(:hidden => false)
  scope :normal, where(:status => 0)
  scope :subfeatured, where(:status => 1)
  scope :featured, where(:status => 2)
  scope :featurish, where('status >= 1')
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
  
  def author?(user)
    user && user == self.user
  end

  def locked?
    Time.now - created_at > 2.weeks
  end

  def status_name
    Content::STATES[status]
  end

  def feature?
    status >= 1
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

  def all_caps
    # 5 is an arbitrary number, where the title is long enough for this error to be meaningful
    if title.length > 5 and title == title.upcase 
      errors.add(:title, "^It looks as though your title is in ALL CAPS. There's no need to scream: try using normal case.")
    end
  end

  def total_votes
    votes.reduce(0) { |sum, v| sum + v.vote }
  end

  def comment_count
    comments.count
  end

  def hide(user, state)
    self.hidden = state
    # We only care which user hid the content
    unless state.to_i.zero?
      self.hidden_user_id = user.id
    end
    save
  end

  # We manually index to solr so that we can handle any exceptions
  # that might be thrown if, eg., solr is down.
  def search_index
    index!
  rescue Errno::ECONNREFUSED
    logger.error "Solr connection refused: unable to index new content (id: #{id})."
  end
end