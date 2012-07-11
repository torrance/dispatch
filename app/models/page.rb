class Page < ActiveRecord::Base
  attr_accessible :title, :path, :body

  validates :title, :path, :body, :presence => true
  validates :path, :uniqueness => true

  def path=(path)
    # Remove leading and trailing slashes
    path.sub!(/^\/*/, '')
    path.sub!(/\/*$/, '')
    write_attribute(:path, path)
  end

  def to_param
    path
  end
end
