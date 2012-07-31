class Event < Content
  attr_accessible :start, :location

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
end
