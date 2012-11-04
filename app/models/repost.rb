# encoding: utf-8

class Repost < Content
  attr_accessible :url, :url_name, :repost_permission, :as => [:default, :editor]

  # Custom setters
  # Prepend url values with http:// if necessary
  def url=(string)
    unless string.index("http://") || string.index("https://")
      string = "http://" + string
    end
    write_attribute(:url, string)
  end

  # Validations
  # URL regex taken from http://www.railsmine.net/2010/09/ruby-way-to-do-url-validation.html
  validates :url, :format => { :with => /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$/ix,
    :message => "^The original url doesn't appear to be a valid address" }

  # Solr search configuration
  searchable :auto_index => false do
    text :title, :more_like_this => true
    text :summary, :more_like_this => true
    text :body, :more_like_this => true
    text :tag_list, :boost => 2.0, :more_like_this => true
    time :created_at, :trie => true
    integer :status
    boolean :hidden
    string :category
    string :tag_list, :multiple => true
    string :type
  end
end
