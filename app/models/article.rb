class Article < Content
  # Solr search configuration
  searchable :auto_index => false do
    text :title, :more_like_this => true
    text :summary, :more_like_this => true
    text :body, :more_like_this => true
    text :tag_list, :boost => 2.0
    time :created_at, :trie => true
    integer :status
    string :category
    string :tag_list, :multiple => true
    string :type
  end
end
