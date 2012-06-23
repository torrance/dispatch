class Image < ActiveRecord::Base
  attr_accessible :image, :weight
  belongs_to :content

  has_attached_file :image, :styles => { :article => ["700x467", :jpg] }
end
