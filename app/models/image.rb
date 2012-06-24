class Image < ActiveRecord::Base
  attr_accessible :image, :weight
  belongs_to :content

  validates :image_file_name, :presence => true

  default_scope order('weight ASC')

  has_attached_file :image, :styles => {
    :article => ["700x467", :jpg],
    :tiny => ["60x60", :jpg],
    :gallery_thumbnail => ["95x95#", :jpg],
    :gallery_full => ["900x700", :jpg]
  }
end
