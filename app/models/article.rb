class Article < Content
  acts_as_taggable

  default_scope :include => :tags

  # Validations
  validates :category, :tag_list, :presence => true
  validates :category, :inclusion => { :in => self::CATEGORIES,
    :message => "^You need to select a valid category." }
  validate :tags_limit

  # Solr search configuration
  searchable do
    text :title, :summary, :body
    time :created_at, :trie => true
    string :category
    string :tag_list, :multiple => true
    string :type   
  end

  # Public model methods
  def tags_limit
    errors.add(:tag_list, "^There are too many tags (maximum 5).") unless tag_list.length <= 5
  end

  # Return top 5 article tags that partially match a search string.
  def self.search_tags(search)
    tag_counts_on('tags').limit(5).where('tags.name LIKE ?', "%#{search}%")
  end
end
