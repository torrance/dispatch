class Event < Content
  attr_accessible :start, :location, :as => [:default, :editor]

  validate :start_cannot_be_in_past
  validates :start, :location, :presence => true

  # Solr search configuration
  searchable do
    text :title, :more_like_this => true
    text :summary, :more_like_this => true
    text :body, :more_like_this => true
    time :created_at, :trie => true
    integer :status
    string :category
    string :type   
  end

  scope :upcoming, where("start > ?", DateTime.now.beginning_of_day).order("start ASC")

  def start_cannot_be_in_past
    if new_record? && start < DateTime.now.beginning_of_day
      errors.add(:start, "^Your event cannot start in the past.")
    end
  end

  # Override locked method to lock event once it has been
  def locked?
    Time.now - start > 1.week
  end
end
