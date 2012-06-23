class Image < ActiveRecord::Base
  attr_accessible :image
  belongs_to :article

  has_attached_file :image, :styles => { :article => "720x480", }
end
