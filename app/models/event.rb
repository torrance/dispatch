class Event < Content
  attr_accessible :start, :location

  # Solr search configuration
  searchable do
    text :title, :summary, :body
    time :created_at, :trie => true
    string :category
    string :type   
  end

  scope :upcoming, where("start > ?", DateTime.now.beginning_of_day).order("start ASC")
end
