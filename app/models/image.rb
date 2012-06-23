class Image < ActiveRecord::Base
  attr_accessible :image
  belongs_to :article

  has_attached_file :image, :styles => { :article => ["700x467", :jpg] }
end
