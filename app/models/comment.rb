class Comment < ActiveRecord::Base
  attr_accessible :body, :as => [:default, :editor]
  attr_accessible :status, :as => :editor

  belongs_to :user
  belongs_to :content

  default_scope :include => :user, :include => :content

  scope :recent, order('created_at DESC')
  scope :oldest, order('created_at ASC')
  scope :visible, where(:status => 1)

  validates :user, :content, :presence => true
  validates :body, :length => { 
    :minimum => 1,
    :maximum => 3000,
    :too_short => "^Your comment is empty.",
    :too_long => "^Your comment is too long (maximum is 3000 characters)"
  }

  def visible?
    status == 1
  end

  def hidden?
    status == 0
  end
end
