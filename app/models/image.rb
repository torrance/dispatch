class Image < ActiveRecord::Base
  attr_accessible :image, :weight
  belongs_to :content

  validates :image_file_name, :presence => true

  default_scope order('weight ASC')

  has_attached_file :image, :styles => {
    :article => ["695x470", :jpg],
    :gallery_thumbnail => ["140x140#", :jpg],
    :gallery_full => ["900x900", :jpg],
    :primary_feature => ["510x300#", :jpg],
    :feature_square => ["110x110#", :jpg],
    :sub_feature => ["235x150#", :jpg]
  }
end
