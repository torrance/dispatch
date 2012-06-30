class Comment < ActiveRecord::Base
  attr_accessible :body

  belongs_to :user
  belongs_to :content

  default_scope :include => :user

  validates :user, :content, :presence => true
  validates :body, :length => { 
    :minimum => 1,
    :maximum => 3000,
    :too_short => "^Your comment is empty.",
    :too_long => "^Your comment is too long (maximum is 3000 characters)"
  }
end
